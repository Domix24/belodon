defmodule Mix.Tasks.Belodon.Create do
  @moduledoc """
  Runs all the tests of a puzzle with specific parameters.

  ## Parameters
  - `--year` (`-y`): Target year for the test. Defaults to the environment variable BELODON_TEST_YEAR.
  - `--day` (`-d`): Target day for the test. Defaults to the environment variable BELODON_TEST_DAY.

  ## Examples

      $ mix belodon.test --year 2024 --day 25
      $ mix belodon.test -y 2024 -d 25

  Runs the task with the `year` parameter set to `2024` and the day parameter set to `25`.
  """

  use Mix.Task
  alias Belodon.Types

  @impl Mix.Task
  def run(args) do
    {arg_opts, _} =
      OptionParser.parse!(args,
        switches: [year: :integer, day: :integer],
        aliases: [y: :year, d: :day]
      )

    default_year = fetch_int("BELODON_TEST_YEAR", 0)
    default_day = fetch_int("BELODON_TEST_DAY", 0)

    opts = Keyword.merge([year: default_year, day: default_day], arg_opts)

    valid_year = Types.validate_year!(opts[:year])
    valid_day = Types.validate_day!(opts[:day])

    year = "#{valid_year}"
    day = String.slice("0#{valid_day}", -2, 2)

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

    File.write!(path_solution, EEx.eval_file(template_solution, year: year, day: day))
    File.write!(path_test, EEx.eval_file(template_test, year: year, day: day))
  end

  @spec fetch_int(String.t(), integer) :: integer()
  defp fetch_int(env_var, default_value) do
    env_var
    |> System.get_env("#{default_value}")
    |> String.to_integer()
  rescue
    _ -> default_value
  end

  defp get_template(template) do
    [__DIR__, "..", "..", "template", template]
    |> Path.join()
    |> Path.expand()
  end
end
