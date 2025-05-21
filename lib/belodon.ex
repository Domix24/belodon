defmodule Belodon do
  @moduledoc """
  **Belodon** is a utility module designed to process inputs and
  dynamically execute problem-solving functions based on provided modules.

  It supports two flows:

  - **Direct Input Flow:** Takes a raw input string along with a part indicator (`:part1` or `:part2`),
  processes the input, and then invokes the corresponding `execute/1` function in the submodule.
  - **Auto Input Flow:** Extracts numerical identifiers (typically representing a year and day)
  from the module's name, fetches input data via `Belodon.Input.get/3`, and execute the solution.

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
    - `opts`: A keyword list, where each value is passed to the main function.
  """
  @spec test(module(), binary(), :part1 | :part2, keyword()) :: any()
  def test(module, input, part, opts \\ []) do
    input
    |> prepare()
    |> call(module, part, opts)
  end

  # These functions create a quoted expression that dynamically calls the `execute/1` function
  # or `execute/2` on the respective part of the provided module
  @doc false
  defp execute(module, part) do
    full_module =
      module
      |> get_module(part)
      |> Code.eval_quoted()
      |> elem(0)

    full_module
    |> get_info()
    |> Enum.filter(&(elem(&1, 0) == :execute))
    |> Enum.sort_by(&elem(&1, 1), :desc)
    |> Enum.at(0)
    |> elem(1)
    |> get_execute(full_module)
  end

  @doc false
  defp get_module(module, :part1) do
    quote do
      unquote(module).Part1
    end
  end

  defp get_module(module, :part2) do
    quote do
      unquote(module).Part2
    end
  end

  @doc false
  defp get_info(module) do
    expression =
      quote do
        unquote(module).__info__(:functions)
      end

    expression
    |> Code.eval_quoted()
    |> elem(0)
  end

  @doc false
  defp get_execute(1, module) do
    quote do
      input
      |> var!()
      |> unquote(module).execute()
    end
  end

  defp get_execute(2, module) do
    quote do
      input
      |> var!()
      |> unquote(module).execute(var!(opts))
    end
  end

  # Internal function that evaluates the quoted expression to execute the code
  @doc false
  defp call(input, module, part, opts) do
    new_opts = remove_internal(opts)

    module
    |> execute(part)
    |> Code.eval_quoted(input: input, opts: new_opts)
    |> elem(0)
  end

  @doc false
  @spec remove_internal(keyword()) :: keyword()
  defp remove_internal(opts) do
    Keyword.delete(opts, :trim)
  end

  @doc """
  Automatically retrieves the input based on the module's name and executes the solution.

  This function is tailored for scenarios where your module's name includes numerical identifiers
  (typically a year and a day). It performs the following steps:

  1. **Extract Identifiers:** Uses a regular expression to find numbers in the module name.
  2. **Clean Up:** Trims any leading zeros from the extracted year and day.
  3. **Fetch Input:** Retrieves the problem input using `Belodon.Input.get/3`, passing the day.
  4. **Execution:** Processes the input similar to the direct flow and calls the appropriate solution.

  ## Parameters

    - `module`: The module containing the solution submodules (`Part1` and `Part2`) with embedded year and day.
    - `part`: An atom, either `:part1` or `:part2`, to select which solution to run.
    - `opts`: A keyword list, where each value is passed to the main function and to the file reader.
  """
  @spec solve(module(), :part1 | :part2, keyword()) :: any()
  def solve(module, part, opts \\ []) do
    [[dirty_year], [dirty_day]] = Regex.scan(~r/\d+/, to_string(module), capture: :first)

    [year, day] = Enum.map([dirty_year, dirty_day], &String.trim_leading(&1, "0"))

    year
    |> Belodon.Input.get(day, opts)
    |> String.split("\n")
    |> call(module, part, opts)
  end
end
