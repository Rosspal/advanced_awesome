import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :advanced_awesome, AdvancedAwesomeWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

config :advanced_awesome, :github,
  token: {:system, "GITHUB_TOKEN"},
  url: {:system, "GITHUB_URL", "https://api.github.com"},
  awesome_repo: {:system, "GITHUB_AWESOME_REPO", "h4cc/awesome-elixir"}

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
