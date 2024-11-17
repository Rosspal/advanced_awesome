defmodule Support.Factory do
  @moduledoc false

  alias AdvancedAwesome.Repo

  alias AdvancedAwesome.Schemas.LibrariesLastUpdate

  def build(:libraries_last_update) do
    %LibrariesLastUpdate{
      id: System.unique_integer([:positive, :monotonic]),
      updated_at: Date.utc_today()
    }
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ %{}) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  def update!(entity, attributes \\ %{}) do
    entity |> Ecto.Changeset.change(attributes) |> Repo.update!()
  end
end
