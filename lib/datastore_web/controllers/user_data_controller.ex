defmodule DatastoreWeb.UserDataController do
  use DatastoreWeb, :controller

  alias Datastore.UserDatastore
  alias Datastore.UserDatastore.UserData

  action_fallback DatastoreWeb.FallbackController

  def create_or_update(conn, %{"service_slug" => service_slug, "user_identifier" => user_identifier, "user_data" => user_data_params}) do
    with {:ok, %UserData{} = user_data} <- UserDatastore.create_or_update(Map.merge(user_data_params, %{ "service_slug" => service_slug, "user_identifier" => user_identifier})) do

      conn
      |> put_status(:ok) # TODO: created should be 201
      |> put_resp_header("location", Routes.user_data_path(conn, :show, service_slug: user_data.service_slug, user_identifier: user_data.user_identifier))
      |> render("show.json", user_data: user_data)
    end
  end

  def show(conn, %{"service_slug" => service_slug, "user_identifier" => user_identifier}) do
    user_data = UserDatastore.get_user_data(user_identifier, service_slug)

    case user_data do
      nil -> {:error, :not_found}
      user_data -> render(conn, "show.json", user_data: user_data)
    end
  end
end
