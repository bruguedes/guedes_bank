defmodule GuedesBankWeb.Router do
  use GuedesBankWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug GuedesBankWeb.Plugs.Auth
  end

  scope "/api", GuedesBankWeb do
    pipe_through :api

    scope "/users" do
      resources "/", UsersController, only: [:create]
      post "/authenticate", UsersController, :authenticate
    end
  end

  scope "/api", GuedesBankWeb do
    pipe_through [:api, :auth]

    scope "/users" do
      resources "/", UsersController, only: [:show, :update, :delete]
    end

    scope "/accounts" do
      post "/", AccountsController, :create
      post "/transaction", AccountsController, :transaction
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:guedes_bank, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: GuedesBankWeb.Telemetry
    end
  end
end
