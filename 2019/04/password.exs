defmodule Password do
  def monotonic?(number) do
    pieces = number
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))

    pieces
    |> Enum.with_index
    |> Enum.map(fn { _, idx } -> List.to_tuple(Enum.slice(pieces, idx, 2)) end)
    |> Enum.reduce(true, fn
      { first, second }, acc -> first <= second && acc
      { _ }, acc -> acc
    end)
  end

  def repeated_properly?(number) do
    case Regex.scan(~r/((.)\2+)/, number) do
      nil -> false
      matches -> Enum.any?(matches, fn [ str, _, _] -> String.length(str) === 2 end)
    end

  end

  def acceptable(first, last) do
    for integer <- first..last,
      candidate = to_string(integer),
      repeated_properly?(candidate),
      monotonic?(candidate) do
        candidate
    end
  end
end

IO.inspect length(Password.acceptable(231832, 767346))
