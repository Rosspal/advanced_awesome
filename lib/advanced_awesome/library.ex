defmodule AdvancedAwesome.LibraryProcessor do
  @moduledoc false

  alias AdvancedAwesome.API.Github
  alias AdvancedAwesome.Libraries
  alias AdvancedAwesome.LibrariesLastUpdate

  require Logger

  @reg_github_libs ~r/\* \[\V+\]\(https:\/\/github.com\/(?<owner>[^\/]+)\/+(?<repository>[^\/]+)\) - (?<description>\V+)/
  @reg_header ~r/## (?<header>\D+)/

  def run() do
    with true <- LibrariesLastUpdate.need_update?(),
         {:ok, libs} <- get() do
      chunks = Enum.chunk_every(libs, 50)
      Enum.each(chunks, fn chunk -> enriching(chunk) |> Libraries.save() end)
      LibrariesLastUpdate.set()
      {:ok, :completed}
    else
      {:error, error} when error in [:service_unavailable, :unexpected] ->
        {:error, :retry_later}

      {:error, :not_found} ->
        {:error, :no_retry}

      false ->
        {:ok, :update_not_required}
    end
  end

  @spec get() :: list(map())
  def get do
    with {:ok, encode_content} <- Github.get_awesome_readme_content(),
         {:ok, content} <- Base.decode64(encode_content, ignore: :whitespace) do
      content_list = String.split(content, "\n")
      #      content_list = test()
      parse_fn =
        fn str, acc ->
          cond do
            named_captures = Regex.named_captures(@reg_header, str) ->
              Map.put(acc, :header, named_captures["header"])

            named_captures = Regex.named_captures(@reg_github_libs, str) ->
              lib = %{
                owner: named_captures["owner"],
                repository: named_captures["repository"],
                description: named_captures["description"]
              }

              Map.put(acc, :libs, [Map.put(lib, :header, acc.header) | acc.libs])

            true ->
              acc
          end
        end

      libs = Enum.reduce(content_list, %{header: nil, libs: []}, parse_fn)[:libs]
      {:ok, libs}
    end
  end

  @spec enriching(list(map)) :: list(map())
  def enriching(awesome_libs) do
    enriching_fn =
      fn awesome_lib, acc ->
        with {:ok, repo_info} <- Github.get_repo_info(awesome_lib.owner, awesome_lib.repository),
             {:ok, pushed_at, _} <- DateTime.from_iso8601(repo_info["pushed_at"]) do
          pushed_at = DateTime.to_date(pushed_at)

          lib =
            %{
              stargazers_count: repo_info["stargazers_count"],
              pushed_at: pushed_at,
              homepage: repo_info["homepage"],
              license: repo_info["license"]["name"],
              url: "https://github.com/#{awesome_lib.owner}/#{awesome_lib.repository}"
            }
            |> Map.merge(awesome_lib)

          [lib | acc]
        else
          {:error, _} ->
            acc
        end
      end

    Enum.reduce(awesome_libs, [], enriching_fn)
  end
end
