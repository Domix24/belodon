defmodule MixTest.Tasks.Belodon.Create do
  use ExUnit.Case, async: false
  alias Mix.Tasks.Belodon.Create
  doctest Mix.Tasks.Belodon.Create

  setup_all do
    on_exit(fn ->
      for suffix <- ["year2024"],
          prefix <- ["lib", "test"] do
        [File.cwd!(), prefix, suffix]
        |> Path.join()
        |> File.rm_rf!()
      end
    end)
  end

  setup do
    System.delete_env("BELODON_TEST_YEAR")
    System.delete_env("BELODON_TEST_DAY")
    System.delete_env("BELODON_TEST_MODULE")
  end

  test "run without args" do
    assert_raise ArgumentError, fn ->
      Create.run([])
    end
  end

  test "run with year and day" do
    path1 = Path.join([File.cwd!(), "lib", "year2024", "day20.ex"])
    path2 = Path.join([File.cwd!(), "test", "year2024", "day20_test.exs"])

    Create.run(["--year=2024", "--day=20", "--module=Greeny"])

    assert File.exists?(path1) and File.exists?(path2)
  end

  test "run with year but day in system variable" do
    System.put_env("BELODON_TEST_YEAR", "abc")
    System.put_env("BELODON_TEST_DAY", "3")
    System.put_env("BELODON_TEST_MODULE", "MyCoolModule")

    path1 = Path.join([File.cwd!(), "lib", "year2024", "day03.ex"])
    path2 = Path.join([File.cwd!(), "test", "year2024", "day03_test.exs"])

    Create.run(["-y2024"])

    assert File.exists?(path1) and File.exists?(path2)
  end

  test "two file created with the good template" do
    System.put_env("BELODON_TEST_YEAR", "2024")
    System.put_env("BELODON_TEST_DAY", "9")
    System.put_env("BELODON_TEST_MODULE", "Aletopelta")

    Create.run([])

    lib_path = Path.join([File.cwd!(), "lib", "year2024", "day09.ex"])
    checklib_path = Path.join([File.cwd!(), "test", "task", "create", "check_lib"])

    test_path = Path.join([File.cwd!(), "test", "year2024", "day09_test.exs"])
    checktest_path = Path.join([File.cwd!(), "test", "task", "create", "check_test"])

    same_lib? = File.read!(lib_path) == File.read!(checklib_path)
    same_test? = File.read!(test_path) == File.read!(checktest_path)

    assert same_lib? and same_test?
  end
end
