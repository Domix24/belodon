defmodule Belodon.Types do
  @moduledoc """
  Provides custom types and validation functions.

  This module defines custom types for valid years and valid days,
  and offer helper functions to ensure that provided values conform to these ranges.

  ## Custom Types

    - `t:valid_year/0`: An integer between 2015 and 3000 (inclusive)
    - `t:valid_day/0`: An integer between 1 and 25 (inclusive).

  These types help ensure that year and day values are within the expected bounds.
  """

  @typedoc """
  Represents a valid year for the challenge, an integer between 2015 and 3000 (inclusive).

  ## Examples

      iex> is_integer(2023) and 2015 <= 2023 and 2023 <= 3000
      true
  """
  @type valid_year :: 2015..3000

  @typedoc """
  Represents a valid day for the challenge, an integer between 1 and 25 (inclusive).

  ## Examples

      iex> is_integer(10) and 1 <= 10 and 10 <= 25
      true
  """
  @type valid_day :: 1..25

  @doc """
  Validates that the given year is within the allowed range (2015 to 3000).

  ## Parameters

    - `year`: An integer representing the year to be validated.

  ## Returns

    - The validated year if it is within the accepted range.

  ## Examples

      iex> Belodon.Types.validate_year!(2024)
      2024

      iex> Belodon.Types.validate_year!(2014)
      ** (ArgumentError) Year must be between 2015 and 3000.

  ## Errors

  Raises an `ArgumentError` if the provided year is not within the allowed range.
  """
  @spec validate_year!(integer()) :: valid_year
  def validate_year!(year) when year in 2015..3000, do: year
  def validate_year!(_), do: raise(ArgumentError, message: "Year must be between 2015 and 3000.")

  @doc """
  Validates that the given day is within the allowed range (1 to 25).

  ## Parameters

    - `day`: An integer representing the day to be validated.

  ## Returns

    - The validated day if it is within the accepted range.

  ## Examples

      iex> Belodon.Types.validate_day!(20)
      20

      iex> Belodon.Types.validate_day!(30)
      ** (ArgumentError) Day must be between 1 and 25.

  ## Errors

  Raises an `ArgumentError` if the provided day is not within the allowed range.
  """
  @spec validate_day!(integer()) :: valid_day
  def validate_day!(day) when day in 1..25, do: day
  def validate_day!(_), do: raise(ArgumentError, message: "Day must be between 1 and 25.")

  @doc """
  Validates that the given module name is not empty and is a string.

  ## Parameters

    - `module`: The module name to be validated, provided as a string.

  ## Returns

    - The validated module name as a string if it is non-empty.

  ## Examples

      iex> Belodon.Types.validate_module!("MyCoolModule")
      "MyCoolModule"

      iex> Belodon.Types.validate_module!("")
      ** (ArgumentError) Module must be named.

      iex> Belodon.Types.validate_module!(:my_cool_module)
      ** (ArgumentError) Module must be a string.

      iex> Belodon.Types.validate_module!(23)
      ** (ArgumentError) Module must be a string.

      iex> Belodon.Types.validate_module!(true)
      ** (ArgumentError) Module must be a string.

      iex> Belodon.Types.validate_module!(["my", "cool", "module"])
      ** (ArgumentError) Module must be a string.

      iex> Belodon.Types.validate_module!({"my", "cool", "module"})
      ** (ArgumentError) Module must be a string.

  ## Errors

  Raises an `ArgumentError` if the module name is either empty or not a string.
  """
  @spec validate_module!(binary) :: binary
  def validate_module!(""), do: raise(ArgumentError, message: "Module must be named.")

  def validate_module!(module) when not is_binary(module),
    do: raise(ArgumentError, message: "Module must be a string.")

  def validate_module!(module), do: module
end
