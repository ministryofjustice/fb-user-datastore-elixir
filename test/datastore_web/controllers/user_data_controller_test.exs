defmodule DatastoreWeb.UserDataControllerTest do
  use DatastoreWeb.ConnCase

  alias Datastore.UserDatastore
  alias Datastore.UserDatastore.UserData

  @create_attrs %{
    service_slug: "some service_slug",
    user_identifier: "7488a646-e31f-11e4-aace-600308960662",
    payload: "encrypted_payload"
  }
  @update_attrs %{
    service_slug: "some updated service_slug",
    user_identifier: "7488a646-e31f-11e4-aace-600308960668",
    payload: "updated_encrypted_payload"
  }

  def fixture(:user_data) do
    {:ok, user_data} = UserDatastore.create_user_data(@create_attrs)
    user_data
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "post /service/:service_slug/user/:user_identifier" do
    test 'when valid creates the user data', %{conn: conn} do
      conn = post(
        conn,
        Routes.create_or_update_user_data_path(
          conn,
          :create_or_update,
          @create_attrs[:service_slug],
          @create_attrs[:user_identifier]
        ),
        user_data: @create_attrs
      )

      response = json_response(conn, 201)
      assert response["user_id"] == @create_attrs[:user_identifier]
      assert response["service_slug"] == @create_attrs[:service_slug]
      assert response["payload"] == @create_attrs[:payload]
      assert response["timestamp"]
    end

    test 'when valid and exists updates the user data', %{conn: conn} do
      user_data = fixture(:user_data)
      conn = post(
        conn,
        Routes.create_or_update_user_data_path(
          conn,
          :create_or_update,
          user_data.service_slug,
          user_data.user_identifier
        ),
        user_data: %{
          payload: "updated_encrypted_payload"
        }
      )

      response = json_response(conn, 200)
      assert response["payload"] == "updated_encrypted_payload"
    end

    test 'when invalid the user data', %{conn: conn} do
      conn = post(
        conn,
        Routes.create_or_update_user_data_path(
          conn,
          :create_or_update,
          "a",
          "b"
        ),
        user_data: @invalid_attrs
      )
      assert json_response(conn, 404)
    end
  end

  describe "get /service/:service_slug/user/:user_identifier" do
    setup [:create_user_data]

    test "when exists returns user data", %{conn: conn, user_data: user_data} do
      conn = get(
        conn,
        Routes.user_data_path(
          conn, :show, user_data.service_slug, user_data.user_identifier
        )
      )
      assert %{
        "service_slug" => user_data.service_slug,
        "user_id" => user_data.user_identifier,
        "payload" => "encrypted_payload",
        "timestamp" => NaiveDateTime.to_iso8601(user_data.created_at)
      } == json_response(conn, 200)
    end

    test "when does not exist returns not found", %{conn: conn} do
      conn = get(
        conn,
        Routes.user_data_path(
          conn, :show, "my-service-dont-exist", "c1259ed8-8aed-4f6f-a2b6-89b4c5d1ab12"
        )
      )
      assert %{"errors" => %{"message" => "Not Found"}} == json_response(conn, 404)
    end
  end

#  describe "create user_data" do
#    test "renders user_data when data is valid", %{conn: conn} do
#      conn = post(
#        conn,
#        Routes.create_or_update_user_data_path(
#          conn,
#          :create_or_update,
#          "some service slug",
#          "7488a646-e31f-11e4-aace-600308960662"
#        ),
#        user_data: @create_attrs
#      )
#      assert %{
#               "id" => id,
#               "service_slug" => "some service_slug",
#               "user_id" => "7488a646-e31f-11e4-aace-600308960662"
#              } = json_response(conn, 201)
#
#      conn = get(conn, Routes.user_data_path(conn, :show, "some service slug", id))
#
#      assert %{
#               "id" => id,
#               "service_slug" => "some service_slug",
#               "user_id" => "7488a646-e31f-11e4-aace-600308960662"
#             } = json_response(conn, 200)
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post(conn,
#        Routes.create_or_update_user_data_path(
#          conn,
#          :create_or_update,
#          "foo",
#          "bar"
#        ), user_data: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#
#  describe "update user_data" do
#    setup [:create_user_data]
#
#    test "renders user_data when data is valid", %{conn: conn} do
#      conn = get(
#        conn,
#        Routes.user_data_path(
#          conn, :show,
#          "some service_slug",
#          "7488a646-e31f-11e4-aace-600308960662"
#        )
#      )
#
#      assert %{
#               "service_slug" => "some updated service_slug",
#               "user_identifier" => "7488a646-e31f-11e4-aace-600308960668",
#               "payload" => ""
#             } = json_response(conn, 200)
#    end
#
#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post(conn,
#        Routes.create_or_update_user_data_path(
#          conn,
#          :create_or_update,
#          "7488a646-e31f-11e4-aace-600308960668",
#          "foo"
#        ), user_data: @invalid_attrs)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end

  defp create_user_data(_) do
    user_data = fixture(:user_data)
    %{user_data: user_data}
  end
end
