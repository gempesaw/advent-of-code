defmodule Opcode do
  def do_code(input, 1, pos1, pos2, store) do
    val = Enum.at(input, pos1) + Enum.at(input, pos2)
    List.replace_at(input, store, val)
  end

  def do_code(input, 2, pos1, pos2, store) do
    val = Enum.at(input, pos1) * Enum.at(input, pos2)
    List.replace_at(input, store, val)
  end

  def do_code(input, 3, store, val) do
    List.replace_at(input, store, val)
  end

  def do_code(input, current, store, _ \\ nil, _ \\ nil)

  def do_code(input, 4, _, _, _) do
    input
  end

  def do_code(input, 5, _, _, _), do: input

  def do_code(input, 6, _, _, _), do: input

  def do_code(input, 7, pos1, pos2, store) do
    val =
      case Enum.at(input, pos1) < Enum.at(input, pos2) do
        true -> 1
        false -> 0
      end

    List.replace_at(input, store, val)
  end

  def do_code(input, 8, pos1, pos2, store) do
    val =
      case Enum.at(input, pos1) == Enum.at(input, pos2) do
        true -> 1
        false -> 0
      end

    List.replace_at(input, store, val)
  end

  def handle(input, instruction \\ [0], pos \\ 0, output \\ nil) do
    handle(input, Enum.at(input, pos), instruction, pos, output)
  end

  def handle(_, 99, _, _, output) do
    output
  end

  def handle(input, current, inputs, pos, output) when current <= 4 do
    incr = get_incr(current)
    next_pos = pos + incr

    args = Enum.slice(input, pos, incr)

    next_instruction =
      case current do
        3 -> Enum.drop(inputs, 1)
        _ -> inputs
      end

    IO.inspect current: current, inputs: inputs, next_instruction: next_instruction
    next_input =
      case current do
        3 -> apply(Opcode, :do_code, [input] ++ args ++ [hd(inputs)])
        _ -> apply(Opcode, :do_code, [input] ++ args)
      end

    next_output =
      case current do
        4 -> Enum.at(input, Enum.at(args, 1))
        _ -> output
      end

    real_next_pos =
      get_next_pos(input, current, Enum.at(input, pos + 1), Enum.at(input, pos + 2), next_pos)

    handle(
      next_input,
      Enum.at(next_input, next_pos),
      next_instruction,
      real_next_pos,
      next_output
    )
  end

  def handle(input, maybe_short_parameter, inputs, pos, output) do
    {params, code} =
      maybe_short_parameter
      |> to_string
      |> String.pad_leading(5, "0")
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> Enum.split(3)

    current =
      code
      |> Enum.join("")
      |> String.to_integer()

    args =
      params
      |> Enum.reverse()
      |> Stream.with_index()
      |> Enum.map(fn
        {0, index} -> Enum.at(input, pos + index + 1)
        {1, index} -> pos + index + 1
      end)

    next_instruction =
      case current do
        3 -> Enum.drop(inputs, 1)
        _ -> inputs
      end

    IO.inspect current: current, inputs: inputs, next_instruction: next_instruction
    next_input =
      case current do
        3 -> apply(Opcode, :do_code, [input] ++ [current] ++ args ++ [hd(inputs)])
        _ -> apply(Opcode, :do_code, [input] ++ [current] ++ args)
      end

    next_output =
      case current do
        4 -> Enum.at(input, args)
        _ -> output
      end

    real_next_pos =
      apply(
        Opcode,
        :get_next_pos,
        [input] ++ [current] ++ Enum.slice(args, 0, 2) ++ [pos + get_incr(current)]
      )

    handle(
      next_input,
      Enum.at(next_input, real_next_pos),
      next_instruction,
      real_next_pos,
      next_output
    )
  end

  def get_next_pos(input, 5, pos1, pos2, next_pos) do
    case Enum.at(input, pos1) do
      0 -> next_pos
      _ -> Enum.at(input, pos2)
    end
  end

  def get_next_pos(input, 6, pos1, pos2, next_pos) do
    case Enum.at(input, pos1) do
      0 -> Enum.at(input, pos2)
      _ -> next_pos
    end
  end

  def get_next_pos(_, _, _, _, next_pos), do: next_pos

  def get_incr(code) do
    case code do
      1 -> 4
      2 -> 4
      3 -> 2
      4 -> 2
      5 -> 3
      6 -> 3
      7 -> 4
      8 -> 4
      99 -> 0
    end
  end

  def search(goal, input) do
    for noun <- 0..99,
        verb <- 0..99,
        input
        |> List.replace_at(1, noun)
        |> List.replace_at(2, verb)
        |> handle
        |> Enum.at(0) == goal do
      IO.puts(noun)
      IO.puts(verb)
    end
  end

  def chainable_handle(output, phase_setting, input) do
    handle(input, [phase_setting, output])
  end

  def permute(_, list \\ [])

  def permute([], list) do
    list
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

  def find_highest_signal(input) do
    for order <- permutations([5, 6, 7, 8, 9]) do
      0
      |> chainable_handle(Enum.at(order, 0), input)
      |> IO.inspect
      |> chainable_handle(Enum.at(order, 1), input)
      |> IO.inspect
      |> chainable_handle(Enum.at(order, 2), input)
      |> IO.inspect
      |> chainable_handle(Enum.at(order, 3), input)
      |> IO.inspect
      |> chainable_handle(Enum.at(order, 4), input)
      |> IO.inspect
    end
  end
end

input = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26, 27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5]

IO.inspect(Enum.max(Opcode.find_highest_signal(input)))
