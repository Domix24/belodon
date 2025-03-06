defmodule Mix.Tasks.Belodon.Test.Behavior do
  @moduledoc """
  Test Behavior
  """
  @callback send(binary) :: binary | :ok
end
