defmodule BelodonTest.Types do
  use ExUnit.Case, async: true
  doctest Belodon.Types

  test "a valid year" do
    for year <- [2015, 2022, 2023, 2024, 3000] do
      assert Belodon.Types.validate_year!(year) == year
    end
  end

  test "not a year in range" do
    for year <- [2014, 3001] do
      assert_raise ArgumentError, fn ->
        Belodon.Types.validate_year!(year)
      end
    end
  end

  test "not a number year" do
    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_year!("2024x")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_year!("x2024")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_year!("x2024x")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_year!("xx")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_year!("")
    end
  end

  test "a valid day" do
    for day <- [1, 23, 25] do
      assert Belodon.Types.validate_day!(day) == day
    end
  end

  test "not a day in range" do
    for day <- [0, 26] do
      assert_raise ArgumentError, fn ->
        Belodon.Types.validate_day!(day)
      end
    end
  end

  test "not a number day" do
    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_day!("25x")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_day!("x25")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_day!("x25x")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_day!("xx")
    end

    assert_raise ArgumentError, fn ->
      Belodon.Types.validate_day!("")
    end
  end
end
