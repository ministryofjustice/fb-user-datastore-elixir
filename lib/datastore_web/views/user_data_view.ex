defmodule DatastoreWeb.UserDataView do
  use DatastoreWeb, :view
  alias DatastoreWeb.UserDataView

  def render("index.json", %{user_data: user_data}) do
    render_many(user_data, UserDataView, "user_data.json")
  end

  def render("show.json", %{user_data: user_data}) do
    render_one(user_data, UserDataView, "user_data.json")
  end

  def render("user_data.json", %{user_data: user_data}) do
    %{
      user_id: user_data.user_identifier,
      service_slug: user_data.service_slug,
      payload: user_data.payload,
      timestamp: Enum.max([user_data.created_at, user_data.updated_at]) |> NaiveDateTime.to_iso8601()
    }
  end
end
