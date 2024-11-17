defmodule AdvancedAwesome.API.Github do
  @moduledoc false

  require Logger

  @awesome_repo Confex.fetch_env!(:advanced_awesome, :github)[:awesome_repo]
  @base_url Confex.fetch_env!(:advanced_awesome, :github)[:url]

  @spec get_awesome_readme_content :: {:ok, String.t()} | {:error, :not_found | :service_unavailable | :unexpected}
  def get_awesome_readme_content do
    url = "#{@base_url}/repos/#{@awesome_repo}/readme"

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           http_client().get(url, headers()),
         {:ok, %{"content" => content}} <- Jason.decode(body) do
      {:ok, content}
    else
      {_, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("get_awesome_readme_content: repository #{@awesome_repo} not found")
        {:error, :not_found}

      {_, %HTTPoison.Response{status_code: status_code}} when status_code >= 500 ->
        Logger.error(
          "get_awesome_readme_content: Service github return status code #{status_code}"
        )

        {:error, :service_unavailable}

      error ->
        Logger.error("get_awesome_readme_content: Unexpected error: #{inspect(error)}")
        {:error, :unexpected}
    end
  end

  @spec get_repo_info(String.t(), String.t()) :: {:ok, map()} | {:error, :not_found | :forbidden | :unexpected}
  def get_repo_info(owner, repo) do
    url = "#{@base_url}/repos/#{owner}/#{repo}"

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           http_client().get(url, headers(), follow_redirect: true),
         {:ok, repo_info} <- Jason.decode(body) do
      {:ok, repo_info}
    else
      {_, %HTTPoison.Response{status_code: 404}} ->
        Logger.error("get_repo_info: repository #{owner}/#{repo} not found")
        {:error, :not_found}

      {_, %HTTPoison.Response{status_code: 403}} ->
        Logger.error("get_repo_info: access to repository #{owner}/#{repo} denied")
        {:error, :forbidden}

      error ->
        Logger.error("get_repo_info: #{inspect(error)}")
        {:error, :unexpected}
    end
  end

  defp headers do
    token = "Bearer " <> Confex.fetch_env!(:advanced_awesome, :github)[:token]
    [{"authorization", token}]
  end

  defp http_client do
    Application.get_env(:advanced_awesome, :http_adapter, HTTPoison)
  end
end
