defmodule Belodon.Input do
  @moduledoc """
  Module responsible for handling input retrieval and caching

  This module provides facilities to obtain input data for a given year and day by:

    1. **Building a local storage path:** A file path is generated where the input will be cached.
    2. **Checking for cached input:** If the file exists locally, its contents are returned.
    3. **Fetching remote input:** If not cached, input is fetched from an external source,
       its body is processed, and then written locally.

  ## Workflow overview
  <pre>
  <code class="mermaid">
  graph TD
  A["Generate local file path based on year/day"] --> B["If file exists?"]
  B -- "No" --> C["Build external input path for fetching"]
  B -- "Yes" --> F
  C --> D["Fetch input data"]
  D --> E["Process & cache input locally"]
  E --> F["Process local file & return content"]
  </code>
  </pre>
  """
  alias Belodon.Input.Behavior.Mock

  @doc false
  @spec callme :: :nice
  def callme do
    :nice
  end

  @doc """
  Retrieves the input data for a given `year` and `day`.

  This function is the primary entry point for obtaining problem input. It works as follows:

    1. **Local Path Generation:** Computes the local file path.
    2. **Cache Check:** If the file does not exist, it will:
         - Build an external path.
         - Fetch the input
         - Trim and cache the fetched content locally using `write_file!/2`.
    3. **Return Value:** Reads and returns the contents of the local file.

  ## Parameters

    - `year`: A binary representing the year (e.g., `"2023"`).
    - `day`: A binary representing the day (e.g., `"15"`).
    - `opts`: A keyword list impacting the way data is stored in the file. See [Options](`get/3#options`).

  ## Options

    - `:trim`: Set to `false` if data should not be trimmed (Default: `true`)

  ## Returns

    - A binary containing the input data.
  """
  @spec get(binary(), binary(), keyword()) :: binary()
  def get(year, day, opts \\ []) do
    local_name = build_local_path(year, day)

    if !File.exists?(local_name) do
      year
      |> build_external_path(day)
      |> Mock.fetch_input!()
      |> Map.fetch!(:body)
      |> trim(Keyword.get(opts, :trim, true))
      |> write_file!(local_name)
    end

    File.read!(local_name)
  end

  @doc false
  @spec trim(binary, boolean) :: binary
  defp trim(content, false), do: content
  defp trim(content, true), do: String.trim(content)

  @doc false
  @spec build_local_path(binary, binary) :: binary
  defp build_local_path(year, day) do
    "#{File.cwd!()}/input/#{year}/#{day}"
  end

  @doc false
  @spec build_external_path(binary, binary) :: binary
  defp build_external_path(year, day) do
    "#{year}/day/#{day}/input"
  end

  @doc """
  Writes the given `content` to the file at the specified `path`.

  Before writing, it ensures that the target directory exists by creating it if necessary.

  ## Parameters

    - `content`: The content to be written.
    - `path`: The complete file path where the content should be stored.

  ## Returns

    - `:ok` upon successful file write.
  """
  @spec write_file!(iodata, Path.t()) :: :ok
  def write_file!(content, path) do
    path
    |> Path.dirname()
    |> File.mkdir_p!()

    File.write!(path, content)
  end
end
