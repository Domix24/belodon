defmodule BelodonTest.Input do
  use ExUnit.Case, async: true
  doctest Belodon.Input

  setup_all do
    on_exit(fn ->
      [File.cwd!(), "input", "2025"]
      |> Path.join()
      |> File.rm_rf()
    end)
  end

  test "callme" do
    assert Belodon.Input.callme() == :nice
  end

  test "get an existing file" do
    path = Path.join([File.cwd!(), "input", "2024", "25"])
    expected = "new gift\n2024\n25"

    assert File.exists?(path)
    assert Belodon.Input.get(2024, 25) == expected
  end

  test "trim content while writing to file" do
    path = Path.join([File.cwd!(), "input", "2025", "26"])

    assert !File.exists?(path)
    assert Belodon.Input.get(2025, 26) == "new gift\n2025\n26"
  end

  test "no trim content while writing to file" do
    path = Path.join([File.cwd!(), "input", "2025", "27"])

    assert !File.exists?(path)
    assert Belodon.Input.get(2025, 27, trim: false) == "new gift\n2025\n27\n"
  end

  test "get a missing file" do
    path = Path.join([File.cwd!(), "input", "2025", "12"])

    assert !File.exists?(path)
    assert Belodon.Input.get(2025, 12) == "new gift\n2025\n12"
  end
end
