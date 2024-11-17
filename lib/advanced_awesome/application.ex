defmodule AdvancedAwesome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        AdvancedAwesome.Repo,
        {Phoenix.PubSub, name: AdvancedAwesome.PubSub},
        AdvancedAwesomeWeb.Endpoint
      ] ++ update_scheduler()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AdvancedAwesome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdvancedAwesomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  if Mix.env() != :test do
    defp update_scheduler do
      [AdvancedAwesome.UpdateScheduler]
    end
  else
    defp update_scheduler, do: []
  end
end
