defmodule DatastoreWeb.Router do
  use DatastoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", DatastoreWeb do
    pipe_through :api

    post "/service/:service_slug/user/:user_identifier", UserDataController, :create_or_update, as: :create_or_update_user_data
    get "/service/:service_slug/user/:user_identifier", UserDataController, :show, as: :user_data
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: DatastoreWeb.Telemetry
    end
  end
end
