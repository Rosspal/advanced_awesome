defmodule AdvancedAwesome.Schemas.Libraries do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @required_fields [
    :owner,
    :repository,
    :stargazers_count,
    :pushed_at,
    :url,
    :header,
    :description
  ]
  @optional_fields [:license, :homepage]

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

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint([:owner, :repository])
  end
end
