defmodule AdvancedAwesome.LibraryProcessorTest do
  use AdvancedAwesome.DataCase, async: true

  import Mox

  alias AdvancedAwesome.LibraryProcessor
  alias AdvancedAwesome.Repo
  alias AdvancedAwesome.Schemas.Libraries
  alias Support.Factory

  @http_client HttpAdapterMock
  @awesome_repo Confex.fetch_env!(:advanced_awesome, :github)[:awesome_repo]
  @base_url Confex.fetch_env!(:advanced_awesome, :github)[:url]

  describe "Readme:" do
    test "parse base string" do
      content =
        """
        ## Application
        * [alf](https://github.com/antonmi/ALF) - Flow-based Application Layer Framework.
        ## HTML
        * [array](https://github.com/takscape/elixirarray) - An Elixir wrapper library for Erlang's array.
        """
        |> Base.encode64()

      Jason.encode!(%{"content" => content})
      |> mock_readme()

      assert LibraryProcessor.get() ==
               {:ok,
                [
                  %{
                    owner: "takscape",
                    header: "HTML",
                    description: "An Elixir wrapper library for Erlang's array.",
                    repository: "elixirarray"
                  },
                  %{
                    owner: "antonmi",
                    header: "Application",
                    description: "Flow-based Application Layer Framework.",
                    repository: "ALF"
                  }
                ]}
    end

    test "parsing strings with symbols (-_) and numbers" do
      content =
        """
        ## Application
        * [alf](https://github.com/antonmi123/A-L_F-1) - Flow-based Application Layer Framework.
        ## HTML
        * [array](https://github.com/3takscape/el-2-ixir_ar-ray) - An Elixir wrapper library for Erlang's array.
        """
        |> Base.encode64()

      Jason.encode!(%{"content" => content})
      |> mock_readme()

      assert LibraryProcessor.get() ==
               {:ok,
                [
                  %{
                    owner: "3takscape",
                    header: "HTML",
                    description: "An Elixir wrapper library for Erlang's array.",
                    repository: "el-2-ixir_ar-ray"
                  },
                  %{
                    owner: "antonmi123",
                    header: "Application",
                    description: "Flow-based Application Layer Framework.",
                    repository: "A-L_F-1"
                  }
                ]}
    end

    test "do not parse lines not related to github" do
      content =
        """
        ## Application
        * [alf](https://gitlab.com/antonmi123/A-L_F-1) - Flow-based Application Layer Framework.
        ## HTML
        * [array](https://github.com/3takscape/el-2-ixir_ar-ray) - An Elixir wrapper library for Erlang's array.
        """
        |> Base.encode64()

      Jason.encode!(%{"content" => content})
      |> mock_readme()

      assert LibraryProcessor.get() ==
               {:ok,
                [
                  %{
                    owner: "3takscape",
                    header: "HTML",
                    description: "An Elixir wrapper library for Erlang's array.",
                    repository: "el-2-ixir_ar-ray"
                  }
                ]}
    end

    test "not found" do
      mock_readme("", 404)

      assert LibraryProcessor.get() == {:error, :not_found}
    end

    test "service unavailable" do
      mock_readme("service unavailable", 500)

      assert LibraryProcessor.get() == {:error, :service_unavailable}
    end
  end

  describe "Enriching libs: " do
    test "successful completion" do
      body =
        Jason.encode!(%{
          "stargazers_count" => "100",
          "pushed_at" => "2021-02-28T10:54:31Z",
          "homepage" => "http://homepahe",
          "license" => %{"name" => "MIT"}
        })

      mock_repo_info("owner", "repository", body)

      libs = [
        %{
          owner: "owner",
          header: "HTML",
          description: "An Elixir wrapper library for Erlang's array.",
          repository: "repository"
        }
      ]

      assert LibraryProcessor.enriching(libs) == [
               %{
                 owner: "owner",
                 header: "HTML",
                 description: "An Elixir wrapper library for Erlang's array.",
                 url: "https://github.com/owner/repository",
                 repository: "repository",
                 stargazers_count: "100",
                 pushed_at: ~D[2021-02-28],
                 homepage: "http://homepahe",
                 license: "MIT"
               }
             ]
    end

    test "missing libraries" do
      mock_repo_info("owner", "repository", "", 404)

      libs = [
        %{
          owner: "owner",
          header: "HTML",
          description: "An Elixir wrapper library for Erlang's array.",
          repository: "repository"
        }
      ]

      assert LibraryProcessor.enriching(libs) == []
    end
  end

  describe "LibrariesProcessed.run():" do
    setup do
      content =
        """
        ## Application
        * [alf](https://github.com/owner/repository) - Flow-based Application Layer Framework.
        """
        |> Base.encode64()

      Jason.encode!(%{"content" => content})
      |> mock_readme()

      body =
        Jason.encode!(%{
          "stargazers_count" => 100,
          "pushed_at" => "2021-02-28T10:54:31Z",
          "homepage" => "http://homepahe",
          "license" => %{"name" => "MIT"}
        })

      mock_repo_info("owner", "repository", body)

      :ok
    end

    test "checking successful run when last update date is not set" do
      assert LibraryProcessor.run() == {:ok, :completed}

      assert [
               %{
                 owner: "owner",
                 repository: "repository",
                 description: "Flow-based Application Layer Framework.",
                 stargazers_count: 100,
                 pushed_at: ~D[2021-02-28],
                 homepage: "http://homepahe",
                 license: "MIT",
                 url: "https://github.com/owner/repository",
                 header: "Application"
               }
             ] = Repo.all(Libraries)
    end

    test "checking successful run when last update date is set" do
      old_date = ~D[2021-02-27]
      Factory.insert!(:libraries_last_update, %{updated_at: old_date})

      assert LibraryProcessor.run() == {:ok, :completed}

      assert [
               %{
                 owner: "owner",
                 repository: "repository",
                 description: "Flow-based Application Layer Framework.",
                 stargazers_count: 100,
                 pushed_at: ~D[2021-02-28],
                 homepage: "http://homepahe",
                 license: "MIT",
                 url: "https://github.com/owner/repository",
                 header: "Application"
               }
             ] = Repo.all(Libraries)

      new_date = AdvancedAwesome.LibrariesLastUpdate.get()

      assert new_date != old_date
    end
  end

  def mock_readme(body, status_code \\ 200) do
    @http_client
    |> expect(:get, fn
      "#{@base_url}/repos/#{@awesome_repo}/readme", _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: status_code,
           body: body
         }}
    end)
  end

  def mock_repo_info(owner, repo, body, status_code \\ 200) do
    url = "#{@base_url}/repos/#{owner}/#{repo}"

    @http_client
    |> expect(:get, fn
      ^url, _, _ ->
        {:ok,
         %HTTPoison.Response{
           status_code: status_code,
           body: body
         }}
    end)
  end
end
