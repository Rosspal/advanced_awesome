defmodule AdvancedAwesome.Libraries do
  @moduledoc false

  import Ecto.Query

  alias AdvancedAwesome.Repo
  alias AdvancedAwesome.Schemas.Libraries

  @spec save(list(map)) :: :ok
  def save(libs) when is_list(libs) do
    Repo.insert_all(Libraries, libs,
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: [:owner, :repository]
    )
  end

  @spec list_grouped(integer) :: list(map)
  def list_grouped(min_stars) do
    Libraries
    |> where([l], l.stargazers_count >= ^min_stars)
    |> order_by(:id)
    |> Repo.all()
    |> Enum.group_by(& &1.header)
  end
end
