defmodule AdvancedAwesome.Repo do
  use Ecto.Repo,
    otp_app: :advanced_awesome,
    adapter: Ecto.Adapters.Postgres
end
