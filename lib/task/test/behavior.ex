defmodule Mix.Tasks.Belodon.Test.Behavior do
  @moduledoc false
  @callback send(binary) :: binary | :ok
end
