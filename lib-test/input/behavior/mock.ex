defmodule Belodon.Input.Behavior.Mock do
  @moduledoc """
  (Test) Input Behavior
  """
  @behaviour Belodon.Input.Behavior

  def fetch_input! filepath do
    [[_, year, date]] = Regex.scan ~r/(\d{4}).+(\d{2})/, filepath
    %{body: "new gift\n#{year}\n#{date}\n"}
  end
end
