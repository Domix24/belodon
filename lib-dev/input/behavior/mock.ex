defmodule Belodon.Input.Behavior.Mock do
  @moduledoc false
  @behaviour Belodon.Input.Behavior

  defp create_client do
    Tesla.client([
      {Tesla.Middleware.BaseUrl, System.get_env("BELODON_URL")},
      {Tesla.Middleware.Headers, [{"cookie", "session=#{get_cookie!()}"}]},
      {Tesla.Middleware.Headers, [{"user-agent", "github.com/domix24/belodon"}]},
      {Tesla.Middleware.JSON, engine: JSON}
    ])
  end

  defp get_cookie! do
    get_session_path()
    |> File.read!
    |> String.trim
  end

  defp get_session_path do
    "#{File.cwd!}/.session"
  end

  def fetch_input!(location) do
    %Tesla.Env{body: body} = Tesla.get! create_client(), location
    %{body: body}
  end
end
