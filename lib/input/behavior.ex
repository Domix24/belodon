defmodule Belodon.Input.Behavior do
  @moduledoc false
  @callback fetch_input!(binary) :: Tesla.Env.body()
end
