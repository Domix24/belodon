defmodule MixTest.Tasks.Belodon.Create do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Belodon.Create
  doctest Mix.Tasks.Belodon.Create

  test "run without args" do
    System.delete_env("BELODON_TEST_YEAR")
    System.delete_env("BELODON_TEST_DAY")

    assert_raise ArgumentError, fn ->
      Create.run([])
    end
  end

  test "run with year and day" do
    path1 = Path.join([File.cwd!(), "lib", "year2024", "day20.ex"])
    path2 = Path.join([File.cwd!(), "test", "year2024", "day20_test.exs"])

    Create.run(["--year=2024", "--day=20"])

    both_exists? =
      for path <- [path1, path2], reduce: true do
        acc ->
          acc = File.exists?(path) and acc

          path
          |> Path.dirname()
          |> File.rm_rf()

          acc
      end

    assert both_exists? == true
  end

  test "run with year but day in system variable" do
    System.put_env("BELODON_TEST_YEAR", "abc")
    System.put_env("BELODON_TEST_DAY", "3")

    path1 = Path.join([File.cwd!(), "lib", "year2023", "day03.ex"])
    path2 = Path.join([File.cwd!(), "test", "year2023", "day03_test.exs"])

    Create.run(["-y2023"])

    both_exists? =
      for path <- [path1, path2], reduce: true do
        acc ->
          acc = File.exists?(path) and acc

          path
          |> Path.dirname()
          |> File.rm_rf()

          acc
      end

    assert both_exists? == true
  end
end
