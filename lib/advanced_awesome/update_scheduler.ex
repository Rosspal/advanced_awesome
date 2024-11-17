defmodule AdvancedAwesome.UpdateScheduler do
  @moduledoc false

  use GenServer

  alias AdvancedAwesome.LibraryProcessor

  @end_of_the_day ~T[23:59:59.999]
  @attempt_delay 5 * 60 * 1000

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(_opts) do
    {:ok, %{}, {:continue, []}}
  end

  def handle_info(:work, state) do
    delay =
      LibraryProcessor.run()
      |> define_schedule_delay()

    schedule_work(delay)

    {:noreply, state}
  end

  def handle_continue(state, _opts) do
    delay =
      LibraryProcessor.run()
      |> define_schedule_delay()

    schedule_work(delay)
    {:noreply, state}
  end

  def define_schedule_delay({:error, :retry}) do
    @attempt_delay
  end

  def define_schedule_delay(_) do
    end_day_ms()
  end

  def end_day_ms() do
    now = DateTime.utc_now()
    launch_time = DateTime.new!(Date.utc_today(), @end_of_the_day)
    DateTime.diff(launch_time, now) * 1000
  end

  defp schedule_work(delay) do
    Process.send_after(self(), :work, delay)
  end
end
