defmodule Opcode do
  def do_code(input, 1, pos1, pos2, store) do
    val = Enum.at(input, pos1) + Enum.at(input, pos2)
    IO.puts "storing #{val} at #{store}"
    List.replace_at(input, store, val)
  end

  def do_code(input, 2, pos1, pos2, store) do
    val = Enum.at(input, pos1) * Enum.at(input, pos2)
    IO.puts "storing #{val} at #{store}"
    List.replace_at(input, store, val)
  end

  def do_code(input, 3, store, val) do
    IO.puts "storing #{val} at #{store}"
    List.replace_at(input, store, val)
  end

  def do_code(input, current, store, _ \\ nil, _ \\ nil)

  def do_code(input, 4, store, _, _) do
    IO.puts Enum.at(input, store)
    input
  end

  def do_code(input, 5, _, _, _), do: input

  def do_code(input, 6, _, _, _), do: input

  def do_code(input, 7, pos1, pos2, store) do
    val = case Enum.at(input, pos1) < Enum.at(input, pos2) do
            true -> 1
            false -> 0
          end

    IO.puts "storing #{val} at #{store}"
    List.replace_at(input, store, val)
  end

  def do_code(input, 8, pos1, pos2, store) do
    val = case Enum.at(input, pos1) == Enum.at(input, pos2) do
            true -> 1
            false -> 0
          end

    IO.puts "storing #{val} at #{store}"
    List.replace_at(input, store, val)
  end

  def handle(input, instruction \\ 0, pos \\ 0) do
    handle(input, Enum.at(input, pos), instruction, pos)
  end

  def handle(input, 99, _, _) do
    input
  end

  def handle(input, current, instruction, pos) when current <= 4 do
    IO.inspect current: current, instruction: instruction, pos: pos

    incr = get_incr(current)
    next_pos = pos + incr

    args = Enum.slice(input, pos, incr)
    next_input = case current do
                   3 -> apply(Opcode, :do_code, [ input ] ++ args ++ [instruction])
                   _ -> apply(Opcode, :do_code, [ input ] ++ args)
                 end

    real_next_pos = get_next_pos(input, current, Enum.at(input, pos + 1), Enum.at(input, pos + 2), next_pos)
    handle(next_input, Enum.at(next_input, next_pos), instruction, real_next_pos)
  end

  def handle(input, maybe_short_parameter, instruction, pos) do
    IO.inspect maybe_short_parameter: maybe_short_parameter, instruction: instruction, pos: pos

    { params, code } = maybe_short_parameter
    |> to_string
    |> String.pad_leading(5, "0")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.split(3)

    current = code
    |> Enum.join("")
    |> String.to_integer

    args = params
    |> Enum.reverse
    |> Stream.with_index
    |> Enum.map(fn
      { 0, index } -> Enum.at(input, pos + index + 1)
      { 1, index } -> pos + index + 1
    end)

    IO.inspect current: current, params: params, args: args

    next_input = case current do
                   3 -> apply(Opcode, :do_code, [ input ] ++ [current] ++ args ++ [instruction])
                   _ -> apply(Opcode, :do_code, [ input ] ++ [current] ++ args)
                 end

    real_next_pos = apply(
      Opcode,
      :get_next_pos,
      [input] ++ [current] ++ Enum.slice(args, 0, 2) ++ [pos + get_incr(current)]
    )

    handle(next_input, Enum.at(next_input, real_next_pos), instruction, real_next_pos)
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
      verb <- 0.. 99,
      input
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)
      |> handle
      |> Enum.at(0) == goal do
      IO.puts noun
      IO.puts verb
    end
  end
end

input = [3,225,1,225,6,6,1100,1,238,225,104,0,1102,89,49,225,1102,35,88,224,101,-3080,224,224,4,224,102,8,223,223,1001,224,3,224,1,223,224,223,1101,25,33,224,1001,224,-58,224,4,224,102,8,223,223,101,5,224,224,1,223,224,223,1102,78,23,225,1,165,169,224,101,-80,224,224,4,224,102,8,223,223,101,7,224,224,1,224,223,223,101,55,173,224,1001,224,-65,224,4,224,1002,223,8,223,1001,224,1,224,1,223,224,223,2,161,14,224,101,-3528,224,224,4,224,1002,223,8,223,1001,224,7,224,1,224,223,223,1002,61,54,224,1001,224,-4212,224,4,224,102,8,223,223,1001,224,1,224,1,223,224,223,1101,14,71,225,1101,85,17,225,1102,72,50,225,1102,9,69,225,1102,71,53,225,1101,10,27,225,1001,158,34,224,101,-51,224,224,4,224,102,8,223,223,101,6,224,224,1,223,224,223,102,9,154,224,101,-639,224,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,108,226,226,224,102,2,223,223,1006,224,329,101,1,223,223,1007,677,677,224,1002,223,2,223,1005,224,344,1001,223,1,223,8,226,677,224,1002,223,2,223,1006,224,359,1001,223,1,223,108,226,677,224,1002,223,2,223,1005,224,374,1001,223,1,223,107,226,677,224,102,2,223,223,1006,224,389,101,1,223,223,1107,226,226,224,1002,223,2,223,1005,224,404,1001,223,1,223,1107,677,226,224,102,2,223,223,1005,224,419,101,1,223,223,1007,226,226,224,102,2,223,223,1006,224,434,1001,223,1,223,1108,677,226,224,1002,223,2,223,1005,224,449,101,1,223,223,1008,226,226,224,102,2,223,223,1005,224,464,101,1,223,223,7,226,677,224,102,2,223,223,1006,224,479,101,1,223,223,1008,226,677,224,1002,223,2,223,1006,224,494,101,1,223,223,1107,226,677,224,1002,223,2,223,1005,224,509,1001,223,1,223,1108,226,226,224,1002,223,2,223,1006,224,524,101,1,223,223,7,226,226,224,102,2,223,223,1006,224,539,1001,223,1,223,107,226,226,224,102,2,223,223,1006,224,554,101,1,223,223,107,677,677,224,102,2,223,223,1006,224,569,101,1,223,223,1008,677,677,224,1002,223,2,223,1006,224,584,1001,223,1,223,8,677,226,224,1002,223,2,223,1005,224,599,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,614,101,1,223,223,108,677,677,224,102,2,223,223,1005,224,629,1001,223,1,223,8,677,677,224,1002,223,2,223,1005,224,644,1001,223,1,223,7,677,226,224,102,2,223,223,1006,224,659,1001,223,1,223,1007,226,677,224,102,2,223,223,1005,224,674,101,1,223,223,4,223,99,226]

IO.puts Enum.join(Opcode.handle(input, 5), ",")
