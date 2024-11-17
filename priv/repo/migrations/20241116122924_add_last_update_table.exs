defmodule AdvancedAwesome.Repo.Migrations.AddLastUpdateTable do
  use Ecto.Migration

  def change do
    create table("libraries_last_update") do
      add :updated_at, :date
    end
  end
end
