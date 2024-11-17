defmodule AdvancedAwesome.Schemas.Libraries do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :id, autogenerate: true}
  schema "libraries" do
    field :owner, :string
    field :repository, :string
    field :description, :string
    field :stargazers_count, :integer
    field :pushed_at, :date
    field :homepage, :string
    field :license, :string
    field :url, :string
    field :header, :string
  end
end
