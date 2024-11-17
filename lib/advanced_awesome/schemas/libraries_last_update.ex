defmodule AdvancedAwesome.Schemas.LibrariesLastUpdate do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :id, autogenerate: true}
  schema "libraries_last_update" do
    field :updated_at, :date
  end

  def create_changeset() do
    cast(%__MODULE__{}, %{updated_at: Date.utc_today()}, [:updated_at])
  end

  def update_changeset(last_update) do
    cast(last_update, %{updated_at: Date.utc_today()}, [:updated_at])
  end
end
