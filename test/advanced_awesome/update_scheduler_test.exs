defmodule AdvancedAwesome.UpdateSchedulerTest do
  use AdvancedAwesome.DataCase, async: true

  describe "UpdateScheduler:" do
    test "returns {:ok, pid} on start_link" do
      AdvancedAwesome.LibrariesLastUpdate.set()

      assert {:ok, _pid} = AdvancedAwesome.UpdateScheduler.start_link([])
    end
  end
end
