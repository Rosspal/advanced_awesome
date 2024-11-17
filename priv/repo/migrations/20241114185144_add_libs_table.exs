defmodule AdvancedAwesome.Repo.Migrations.AddLibsTable do
  use Ecto.Migration

  def change do
    create table("libraries") do
      add :owner, :string
      add :repository, :string
      add :stargazers_count, :integer
      add :description, :string
      add :pushed_at, :date
      add :homepage, :string
      add :license, :string
      add :url, :string
      add :header, :string
    end

    create unique_index("libraries", [:owner, :repository])
  end
end
