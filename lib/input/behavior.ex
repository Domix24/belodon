defmodule Belodon.Input.Behavior do
  @moduledoc """
  Input Behavior
  """
  @callback fetch_input!(binary) :: Tesla.Env.body()
end
