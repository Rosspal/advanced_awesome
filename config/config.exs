# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :advanced_awesome,
  ecto_repos: [AdvancedAwesome.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :advanced_awesome, AdvancedAwesomeWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: AdvancedAwesomeWeb.ErrorHTML, json: AdvancedAwesomeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: AdvancedAwesome.PubSub,
  live_view: [signing_salt: "kJB7NSqB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :advanced_awesome, :github,
  url: "https://api.github.com",
  token: System.get_env("GITHUB_TOKEN", "token"),
  awesome_repo: "h4cc/awesome-elixir"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
