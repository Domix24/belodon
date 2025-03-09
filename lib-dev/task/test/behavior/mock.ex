defmodule Mix.Tasks.Belodon.Test.Behavior.Mock do
  @moduledoc false
  @behaviour Mix.Tasks.Belodon.Test.Behavior

  def send path do
    Mix.Tasks.Test.run([path])
    :ok
  end
end
