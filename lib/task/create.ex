defmodule Mix.Tasks.Belodon.Create do
  @moduledoc """
  Generate boilerplate solution and test files for a specific puzzle based on
  the given year, day and module prefix.

  This Mix task creates two files:

    - A solution file under `lib/year<YEAR>/day<DAY>.ex`, which defines a module
      for the puzzle's solution.
    - A test file under `test/year<YEAR>/day<DAY>_test.exs`, which provides a starting
      point for testing the solution.

  ## Command-Line parameters

    - `--year` (`-y`): Specifies the target year for the puzzle.
      Defaults to the environment variable `BELODON_TEST_YEAR`.
    - `--day` (`-d`): Specifies the target day for the puzzle.
      Defaults to the environment variable `BELODON_TEST_DAY`.
    - `--module` (`-m`): Specifies the module prefix to be used for the generated modules.
      Defaults to the environment variable `BELODON_TEST_MODULE`.

  ## Examples

  To create files for the puzzle corresponding to year `2024` and day `25` with
  a module prefix of `MyCoolModule`, you can run:

  ````shell
  $ mix belodon.create --year 2024 --day 25 --module MyCoolModule
  # Alternate invocation using short options
  $ mix belodon.create -y 2024 -d 25 -m MyCoolModule
  ````

  This will generate:

    - A solution file: `lib/year2024/day25.ex` containing the module `MyCoolModule.Year2024.Day25`.
    - A test file: `lib/year2024/day25_test.exs` containing the tests for the solution.
  """

  use Mix.Task
  alias Belodon.Types

  @impl Mix.Task
  def run(args) do
    {arg_opts, _} =
      OptionParser.parse!(args,
        switches: [year: :integer, day: :integer, module: :string],
        aliases: [y: :year, d: :day, m: :module]
      )

    opts = Keyword.merge(get_defaults(), arg_opts)

    valid_year = Types.validate_year!(opts[:year])
    valid_day = Types.validate_day!(opts[:day])
    valid_module = Types.validate_module!(opts[:module])

    year = "#{valid_year}"
    day = String.slice("0#{valid_day}", -2, 2)
    short_day = "#{valid_day}"
    module = valid_module

    template_solution = get_template("solution.eex")
    template_test = get_template("test.eex")

    path_solution = Path.join([File.cwd!(), "lib", "year#{year}", "day#{day}.ex"])
    path_test = Path.join([File.cwd!(), "test", "year#{year}", "day#{day}_test.exs"])

    path_solution
    |> Path.dirname()
    |> File.mkdir_p!()

    path_test
    |> Path.dirname()
    |> File.mkdir_p!()

    File.write!(
      path_solution,
      EEx.eval_file(template_solution, year: year, day: day, short_day: short_day, module: module)
    )

    File.write!(path_test, EEx.eval_file(template_test, year: year, day: day, module: module))
  end

  @doc false
  @spec get_defaults() :: [{:day, integer()} | {:module, binary()} | {:year, integer()}]
  def get_defaults do
    year = fetch_int("BELODON_TEST_YEAR", 0)
    day = fetch_int("BELODON_TEST_DAY", 0)
    module = fetch_binary("BELODON_TEST_MODULE", "")

    [year: year, day: day, module: module]
  end

  @spec fetch_int(String.t(), integer) :: integer()
  defp fetch_int(env_var, default_value) do
    env_var
    |> System.get_env("#{default_value}")
    |> String.to_integer()
  rescue
    _ -> default_value
  end

  @spec fetch_binary(binary, binary) :: binary
  defp fetch_binary(env_var, default_value) do
    System.get_env(env_var, default_value)
  end

  defp get_template(template) do
    [__DIR__, "..", "..", "template", template]
    |> Path.join()
    |> Path.expand()
  end
end
