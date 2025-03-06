defmodule Mix.Tasks.Belodon.Test.Behavior.Mock do
  @moduledoc """
  (Test) Test Behavior
  """
  @behaviour Mix.Tasks.Belodon.Test.Behavior

  def send path do
    path
  end
end
