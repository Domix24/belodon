defmodule Belodon.Types do
  @moduledoc """
  Provides custom types and validation functions
  """

  @type valid_year :: 2022..2024
  @type valid_day :: 1..25

  @doc """
  Validates that the given year is within the allowed range (2022 to 2024).

  ## Parameters
    - `year`: Year to be validated.

  ## Examples

    iex> Belodon.Types.validate_year!(2024)
    2024

    iex> Belodon.Types.validate_year!(2025)
    ** (ArgumentError) Year must be between 2022 and 2024.

  ## Errors
  Raises an `ArgumentError` if the year is not within the allowed range.
  """
  @spec validate_year!(integer()) :: valid_year
  def validate_year!(year) when year in 2022..2024, do: year
  def validate_year!(_), do: raise(ArgumentError, message: "Year must be between 2022 and 2024.")

  @doc """
  Validates that the given day is within the allowed range (1 to 25).

  ## Parameters
    - `day`: Day to be validated.

  ## Examples

    iex> Belodon.Types.validate_day!(20)
    20

    iex> Belodon.Types.validate_day!(30)
    ** (ArgumentError) Day must be between 1 and 25.

  ## Errors
  Raises an `ArgumentError` if the day is not within the allowed range.
  """
  @spec validate_day!(integer()) :: valid_day
  def validate_day!(day) when day in 1..25, do: day
  def validate_day!(_), do: raise(ArgumentError, message: "Day must be between 1 and 25.")

  @doc """
  Validates that the given module is not empty.

  ## Parameters
    - `module`: Module to be validated.

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
  Raises an `ArgumentError` if the module name is empty
  """
  @spec validate_module!(binary) :: binary
  def validate_module!(""), do: raise(ArgumentError, message: "Module must be named.")

  def validate_module!(module) when not is_binary(module),
    do: raise(ArgumentError, message: "Module must be a string.")

  def validate_module!(module), do: module
end
