defmodule BelodonTest do
  use ExUnit.Case, async: true
  doctest Belodon

  defmodule Y9999D32 do
    defmodule Part1 do
      @spec execute(list()) :: list()
      def execute(input), do: ["z" | input]
    end

    defmodule Part2 do
      @spec execute(list(), keyword()) :: list()
      def execute(input, opts), do: ["j" | input] ++ opts
    end
  end

  defmodule Y9999D33 do
    defmodule Part1 do
      @spec execute(list(), keyword()) :: list()
      def execute(input, opts), do: ["y" | input] ++ opts
    end

    defmodule Part2 do
      @spec execute(list(), keyword()) :: list()
      def execute(input, opts), do: ["i" | input] ++ opts
    end
  end

  setup_all do
    on_exit(fn ->
      [File.cwd!(), "input", "9999"]
      |> Path.join()
      |> File.rm_rf()
    end)
  end

  test "greets the world" do
    assert Belodon.hello() == :world
  end

  test "solve with input for part1" do
    assert Belodon.test(Y9999D32, "a", :part1) == ["z"]
    assert Belodon.test(Y9999D32, "a\nb", :part1, a: "b") == ["z", "a"]
    assert Belodon.test(Y9999D32, "a\nb\nc", :part1) == ["z", "a", "b"]
    assert Belodon.test(Y9999D32, "a\nb\nc\n", :part1, b: "e") == ["z", "a", "b", "c"]
  end

  test "solve with input for an invalid `part`" do
    for part <- [:part3, :part4] do
      assert_raise FunctionClauseError, fn ->
        Belodon.test(UnknownModule, "", part)
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

  test "solve with external untrimmed input" do
    assert Belodon.solve(Y9999D32, :part1, trim: false) == ["z", "new gift", "9999", "32", ""]
    assert Belodon.solve(Y9999D32, :part1, param: :one) == ["z", "new gift", "9999", "32", ""]

    assert Belodon.solve(Y9999D32, :part2, param: :two) == [
             "j",
             "new gift",
             "9999",
             "32",
             "",
             {:param, :two}
           ]

    assert Belodon.solve(Y9999D32, :part2) == ["j", "new gift", "9999", "32", ""]
  end

  test "solve with external trimmed input" do
    assert Belodon.solve(Y9999D33, :part1) == ["y", "new gift", "9999", "33"]
    assert Belodon.solve(Y9999D33, :part1, a: "b") == ["y", "new gift", "9999", "33", {:a, "b"}]
    assert Belodon.solve(Y9999D33, :part2) == ["i", "new gift", "9999", "33"]
    assert Belodon.solve(Y9999D33, :part2, c: "d") == ["i", "new gift", "9999", "33", {:c, "d"}]
  end
end
