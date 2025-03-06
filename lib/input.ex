defmodule Belodon.Input do
  @moduledoc """
  Input

  Handle input
  """
  alias Belodon.Input.Behavior.Mock

  @spec callme :: :nice
  def callme do
    :nice
  end

  @spec get(binary(), binary()) :: binary()
  def get(year, day) do
    local_name = build_local_path(year, day)

    if !File.exists?(local_name) do
      year
      |> build_external_path(day)
      |> Mock.fetch_input!()
      |> Map.fetch!(:body)
      |> String.trim()
      |> write_file!(local_name)
    end

    File.read!(local_name)
  end

  @spec build_local_path(any, any) :: binary
  defp build_local_path(year, day) do
    "#{File.cwd!()}/input/#{year}/#{day}"
  end

  @spec build_external_path(any, any) :: binary
  defp build_external_path(year, day) do
    "#{year}/day/#{day}/input"
  end

  @spec write_file!(iodata, Path.t()) :: :ok
  def write_file!(content, path) do
    path
    |> Path.dirname()
    |> File.mkdir_p!()

    File.write!(path, content)
  end
end
