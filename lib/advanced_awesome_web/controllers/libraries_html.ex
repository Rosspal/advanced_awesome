defmodule AdvancedAwesomeWeb.LibrariesHTML do
  use AdvancedAwesomeWeb, :html

  embed_templates "libraries_html/*"

  attr :date, :any, required: true

  def days_without_commit(assigns) do
    days = Date.diff(Date.utc_today(), assigns.date)
    ~H"<%= days %> days ago"
  end
end
