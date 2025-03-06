defmodule BelodonTest.Input do
  use ExUnit.Case, async: true
  doctest Belodon.Input

  test "callme" do
    assert Belodon.Input.callme() == :nice
  end

  test "get an existing file" do
    path = Path.join([File.cwd!(), "input", "2024", "25"])

    expected = "new gift\n2024\n25"

    test =
      Enum.reduce_while(1..2, true, fn _, _ ->
        test = Belodon.Input.get(2024, 25)

        if test == expected do
          {:halt, test}
        else
          File.rm(path)

          {:cont, Belodon.Input.get(2024, 25)}
        end
      end)

    assert test == expected
  end

  test "get a missing file" do
    path = Path.join([File.cwd!(), "input", "2025", "12"])

    path
    |> Path.dirname()
    |> File.rm_rf()

    assert !File.exists?(path)
    assert Belodon.Input.get(2025, 12) == "new gift\n2025\n12"
  end
end
