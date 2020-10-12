import IEx
defmodule DatastoreWeb.UserDataController do
  use DatastoreWeb, :controller

  alias Datastore.UserDatastore
  alias Datastore.UserDatastore.UserData

  action_fallback DatastoreWeb.FallbackController
  plug DatastoreWeb.Plugs.JWTAuthentication

  def create_or_update(
    conn,
    %{
      "service_slug" => service_slug,
      "user_identifier" => user_identifier,
      "user_data" => user_data_params
    }
  ) do
    result = try do
      create_or_update_user_data(conn, Map.merge(user_data_params || %{}, %{"user_identifier" => user_identifier, "service_slug" => service_slug }))
    rescue
      Ecto.Query.CastError -> {:error, :not_found}
    end

    case result do
      {:created, %UserData{} = user_data } ->
        responds_with(conn, :created, user_data: user_data)
      {:ok, %UserData{} = user_data } ->
        responds_with(conn, :ok, user_data: user_data)
      _ ->
        result
    end
  end

  def show(conn, %{"service_slug" => service_slug, "user_identifier" => user_identifier}) do
    user_data = UserDatastore.get_user_data(user_identifier, service_slug)

    case user_data do
      nil -> {:error, :not_found}
      user_data -> render(conn, "show.json", user_data: user_data)
    end
  end

  def responds_with(conn, status, user_data: user_data) do
      conn
      |> put_status(status)
      |> put_resp_header(
        "location",
        Routes.user_data_path(
          conn,
          :show,
          user_data.service_slug,
          user_data.user_identifier
        )
      )
      |> render("show.json", user_data: user_data)
  end

  defp create_or_update_user_data(conn, attributes) do
    user_data = if attributes["user_identifier"] && attributes["service_slug"] do
      UserDatastore.get_user_data(
        attributes["user_identifier"], attributes["service_slug"]
      )
    end

    case user_data do
      nil ->
        with {:ok, %UserData{} = user_data} <- UserDatastore.create_user_data(attributes) do
          { :created, user_data }
        end
      user_data ->
        UserDatastore.update_user_data(user_data, attributes)
    end
  end
end
