defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ChatWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", ChatWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/rooms/:id", RoomLive, :index
    post "/update", PageController, :update
    post "/upload", PageController, :upload
  end

  # scope regulamin

  scope "/regulamin", ChatWeb do
    pipe_through :browser

    get "/", PageController, :regulamin
  end

end
