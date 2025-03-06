defmodule BelodonTest do
  use ExUnit.Case, async: true
  doctest Belodon

  defmodule Y9999D32 do
    defmodule Part1 do
      @spec execute(list()) :: list()
      def execute(input), do: ["z" | input]
    end

    defmodule Part2 do
      def execute(input), do: ["j" | input]
    end
  end

  test "greets the world" do
    assert Belodon.hello() == :world
  end

  test "solve with input for part1" do
    assert Belodon.solve(Y9999D32, "a", :part1) == ["z"]
    assert Belodon.solve(Y9999D32, "a\nb", :part1) == ["z", "a"]
    assert Belodon.solve(Y9999D32, "a\nb\nc", :part1) == ["z", "a", "b"]
    assert Belodon.solve(Y9999D32, "a\nb\nc\n", :part1) == ["z", "a", "b", "c"]
  end

  test "solve with input for an invalid `part`" do
    for part <- [:part3, :part4] do
      assert_raise FunctionClauseError, fn ->
        Belodon.solve(UnknownModule, "", part)
      end
    end
  end

  test "solve without input with an invalid module name" do
    for x <- ["a", "b", "c"] do
      assert_raise MatchError, fn ->
        Belodon.solve(x, :atom)
      end
    end
  end

  test "solve with external input" do
    assert Belodon.solve(Y9999D32, :part2) == ["j", "new gift", "9999", "32"]
  end
end
