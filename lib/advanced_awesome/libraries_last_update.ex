defmodule AdvancedAwesome.LibrariesLastUpdate do
  @moduledoc false

  alias AdvancedAwesome.Repo
  alias AdvancedAwesome.Schemas.LibrariesLastUpdate, as: LLUSchema

  @spec set :: {:ok, map()} | {:error, Ecto.Changeset.t()}
  def set do
    case Repo.one(LLUSchema) do
      nil ->
        LLUSchema.create_changeset()
        |> Repo.insert()

      library_last_update ->
        library_last_update
        |> LLUSchema.update_changeset()
        |> Repo.update()
    end
  end

  @spec need_update? :: boolean()
  def need_update? do
    case Repo.one(LLUSchema) do
      nil ->
        true

      last_update ->
        last_update.updated_at != Date.utc_today()
    end
  end

  @spec get :: map() | nil
  def get, do: Repo.one(LLUSchema)
end
