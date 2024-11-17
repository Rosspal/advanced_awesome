defmodule AdvancedAwesomeWeb.Router do
  use AdvancedAwesomeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {AdvancedAwesomeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AdvancedAwesomeWeb do
    pipe_through :browser

    get "/", LibrariesController, :get_libraries
  end
end
