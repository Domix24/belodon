defmodule MixTest.Tasks.Belodon.Test do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Belodon.Test
  doctest Mix.Tasks.Belodon.Test

  test "no args with trash in system variable" do
    System.put_env("BELODON_TEST_DAY", "abc")

    assert_raise ArgumentError, fn ->
      Test.run([])
    end
  end

  test "normal run with year in variable and day as argument" do
    System.put_env("BELODON_TEST_YEAR", "2024")
    value = Test.run(["-d4"])
    assert value == "test/year2024/day04_test.exs"
  end
end
