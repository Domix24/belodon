defmodule Mix.Tasks.Belodon.Test do
  @moduledoc """
  Execute tests for a specific puzzle based on the provided year and day.

  This task runs tests for a puzzle by determining the appropriate test file path.
  It validates the year and day using the function from `Belodon.Types`, ensuring
  they fall within the allowed ranges.
  If parameters via the command line, the task defaults to the environment variables
  `BELODON_TEST_YEAR` and `BELODON_TEST_DAY`.

  ## Command-Line parameters

    - `--year` (`-y`): Target year for the puzzle.
    Defaults to the value of the environment variable `BELODON_TEST_YEAR`.
    - `--day` (`-d`): Target day for the puzzle.
    Default to the value of the environment variable `BELODON_TEST_DAY`.

  ## Examples

  ````shell
  # Runs tests for the puzzle from year 2024, day 25
  $ mix belodon.test --year 2024 --day 25
  # Alternate invocation using short options
  $ mix belodon. test -y 2024 -d 25
  ````

  The task constructs the test file path in the format
  `test/year<YEAR>/day<DAY>_test.exs` and then execute the tests.
  """

  use Mix.Task
  alias Belodon.Types
  alias Mix.Tasks.Belodon.Test.Behavior.Mock

  @impl Mix.Task
  def run(args) do
    {dirty_opts, _} =
      OptionParser.parse!(args,
        switches: [year: :integer, day: :integer],
        aliases: [y: :year, d: :day]
      )

    default_year = fetch_int("BELODON_TEST_YEAR", 0)
    default_day = fetch_int("BELODON_TEST_DAY", 0)

    opts = Keyword.merge([year: default_year, day: default_day], dirty_opts)

    valid_year = Types.validate_year!(opts[:year])
    valid_day = Types.validate_day!(opts[:day])

    year = "#{valid_year}"
    day = String.slice("0#{valid_day}", -2, 2)

    test_path = "test/year#{year}/day#{day}_test.exs"

    Mock.send(test_path)
  end

  @spec fetch_int(String.t(), integer) :: integer()
  defp fetch_int(env_var, default_value) do
    env_var
    |> System.get_env("#{default_value}")
    |> String.to_integer()
  rescue
    _ -> default_value
  end
end
