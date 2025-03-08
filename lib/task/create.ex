defmodule Mix.Tasks.Belodon.Create do
  @moduledoc """
  Runs all the tests of a puzzle with specific parameters.

  ## Parameters
  - `--year` (`-y`): Target year for the test. Defaults to the environment variable `BELODON_TEST_YEAR`.
  - `--day` (`-d`): Target day for the test. Defaults to the environment variable `BELODON_TEST_DAY`.
  - `--module` (`-m`): Prefix for the created modules. Defaults to the environment variable `BELODON_TEST_MODULE`.

  ## Examples

      $ mix belodon.test --year 2024 --day 25 --module MyCoolModule
      $ mix belodon.test -y 2024 -d 25 -m MyCoolModule

  Runs the task with the `year` parameter set to `2024`, the `day` parameter set to `25` and creating two modules

  * `MyCoolModule.Year2024.Day25`
  * `MyCoolModuleTest.Year2023.Day25`
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
