defmodule Belodon do
  @moduledoc """
  Documentation for `Belodon`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Belodon.hello()
      :world

  """
  @spec hello() :: :world
  def hello do
    :world
  end

  defp prepare(input) do
    input
    |> String.split("\n")
    |> Enum.drop(-1)
  end

  @spec solve(any(), binary(), :part1 | :part2) :: any()
  def solve(module, input, part) do
    input
    |> prepare()
    |> call(module, part)
  end

  defp execute(module, :part1) do
    quote do
      input
      |> var!()
      |> unquote(module).Part1.execute()
    end
  end

  defp execute(module, :part2) do
    quote do
      input
      |> var!()
      |> unquote(module).Part2.execute()
    end
  end

  defp call(input, module, part) do
    module
    |> execute(part)
    |> Code.eval_quoted(input: input)
    |> elem(0)
  end

  @spec solve(any(), :part1 | :part2) :: any()
  def solve(module, part) do
    [[dirty_year], [dirty_day]] = Regex.scan(~r/\d+/, to_string(module), capture: :first)

    [year, day] = Enum.map([dirty_year, dirty_day], &String.trim_leading(&1, "0"))

    year
    |> Belodon.Input.get(day)
    |> String.split("\n")
    |> call(module, part)
  end
end
