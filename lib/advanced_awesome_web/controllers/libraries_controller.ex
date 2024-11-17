defmodule AdvancedAwesomeWeb.LibrariesController do
  use AdvancedAwesomeWeb, :controller

  alias AdvancedAwesome.Libraries

  def get_libraries(conn, params) do
    min_stars = get_min_stars(params)

    libraries = Libraries.list_grouped(min_stars)

    render(conn, :index, libs: libraries)
  end

  defp get_min_stars(%{"min_stars" => min_stars}) do
    case Integer.parse(min_stars) do
      {value, _} -> value
      :error -> 0
    end
  end

  defp get_min_stars(_), do: 0
end
