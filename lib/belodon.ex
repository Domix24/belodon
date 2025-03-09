defmodule Belodon do
  @moduledoc """
  **Belodon** is a utility module designed to process inputs and
  dynamically execute problem-solving functions based on provided modules.

  It supports two flows:

  - **Direct Input Flow:** Takes a raw input string along with a part indicator (`:part1` or `:part2`),
  processes the input, and then invokes the corresponding `execute/1` function in the submodule.
  - **Auto Input Flow:** Extracts numerical identifiers (typically representing a year and day)
  from the module's name, fetches input data via `Belodon.Input.get/2`, and execute the solution.

  ## Usage

  To use this module, create your own module using `mix belodon.create`. Code will be generated in the
  test folder using the module
  """

  @doc """
  Hello world.

  ## Examples

      iex> Belodon.hello()
      :world

  """
  @spec hello() :: :world
  def hello do
    :world
  end

  # Internal helper to prepare the input by splitting into lines and dropping the last one
  @doc false
  defp prepare(input) do
    input
    |> String.split("\n")
    |> Enum.drop(-1)
  end

  @doc """
  Processes a raw input string and executes the corresponding solution function.

  The process involves:

    1. **Preparation:** The input is split into a list of lines and the last (potentially empty) line is removed.
    2. **Execution:** Based on the `part` parameter, it dynamically quotes and evaluates code to call
       the `execute/1` function from the given module's respective nested module (`Part1` or `Part2`).

  ### Parameters

    - `module`: The module that contains nested submodules (`Part1` and `Part2`) with an `execute/1` function.
    - `input`: A multi-line string with the problem input.
    - `part`: An atom: either `:part1` or `:part2`, which selects the corresponding solution.
  """
  @spec solve(module(), binary(), :part1 | :part2) :: any()
  def solve(module, input, part) do
    input
    |> prepare()
    |> call(module, part)
  end

  # These functions create a quoted expression that dynamically calls the `execute/1` function
  # on the respective part of the provided module
  @doc false
  defp execute(module, :part1) do
    quote do
      input
      |> var!()
      |> unquote(module).Part1.execute()
    end
  end

  @doc false
  defp execute(module, :part2) do
    quote do
      input
      |> var!()
      |> unquote(module).Part2.execute()
    end
  end

  # Internal function that evaluates the quoted expression to execute the code
  @doc false
  defp call(input, module, part) do
    module
    |> execute(part)
    |> Code.eval_quoted(input: input)
    |> elem(0)
  end

  @doc """
  Automatically retrieves the input based on the module's name and executes the solution.

  This function is tailored for scenarios where your module's name includes numerical identifiers
  (typically a year and a day). It performs the following steps:

  1. **Extract Identifiers:** Uses a regular expression to find numbers in the module name.
  2. **Clean Up:** Trims any leading zeros from the extracted year and day.
  3. **Fetch Input:** Retrieves the problem input using `Belodon.Input.get/2`, passing the day.
  4. **Execution:** Processes the input similar to the direct flow and calls the appropriate solution.

  ## Parameters

    - `module`: The module containing the solution submodules (`Part1` and `Part2`) with embedded year and day.
    - `part`: An atom, either `:part1` or `:part2`, to select which solution to run.
  """
  @spec solve(module(), :part1 | :part2) :: any()
  def solve(module, part) do
    [[dirty_year], [dirty_day]] = Regex.scan(~r/\d+/, to_string(module), capture: :first)

    [year, day] = Enum.map([dirty_year, dirty_day], &String.trim_leading(&1, "0"))

    year
    |> Belodon.Input.get(day)
    |> String.split("\n")
    |> call(module, part)
  end
end
