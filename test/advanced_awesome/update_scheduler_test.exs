defmodule AdvancedAwesome.UpdateSchedulerTest do
  use AdvancedAwesomeWeb.ConnCase, async: true
  alias AdvancedAwesome.Repo
  import Mox

  @http_client HttpAdapterMock
  @awesome_repo Confex.fetch_env!(:advanced_awesome, :github)[:awesome_repo]
  @base_url Confex.fetch_env!(:advanced_awesome, :github)[:url]

  describe "Readme:" do
    test "parse base string" do
      AdvancedAwesome.LibrariesLastUpdate.set()



      assert {:ok, _pid} = AdvancedAwesome.UpdateScheduler.start_link([])

    end
  end
end
