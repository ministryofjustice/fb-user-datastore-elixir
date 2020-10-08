defmodule Datastore.UserDatastoreTest do
  use Datastore.DataCase

  alias Datastore.UserDatastore

  @valid_attrs %{
    payload: "some payload",
    service_slug: "cica",
    user_identifier: "7488a646-e31f-11e4-aace-600308960662"
  }
  @invalid_attrs %{payload: nil, service_slug: nil, user_identifier: nil}

  def user_data_fixture(attrs \\ %{}) do
    { :ok, user_data } =
      attrs
      |> Enum.into(@valid_attrs)
      |> UserDatastore.create_user_data()

    user_data
  end

  describe "create_or_update" do
    alias Datastore.UserDatastore.UserData

    test "create data when valid and do not exist" do
      assert {:ok, %UserData{} = user_data } = UserDatastore.create_or_update(@valid_attrs)
      assert user_data.payload == "some payload"
      assert user_data.service_slug == "cica"
      assert user_data.user_identifier == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "update data when valid and does exist" do
      assert UserDatastore.store_size() == 0
      user_data = user_data_fixture()
      assert user_data.__meta__.state == :loaded
      assert UserDatastore.store_size() == 1
      UserDatastore.create_or_update(%{
        user_identifier: user_data.user_identifier,
        service_slug: user_data.service_slug,
        payload: "updated payload"
      })
      assert UserDatastore.store_size() == 1
      assert UserDatastore.get_user_data(
        user_data.user_identifier,
        user_data.service_slug
      ) == %Datastore.UserDatastore.UserData{
        id: user_data.id,
        payload: "updated payload",
        service_slug: "cica",
        user_identifier: user_data.user_identifier,
        created_at: user_data.created_at,
        updated_at: user_data.updated_at,
        __meta__: user_data.__meta__
      }
    end

    test "returns error when invalid data" do
      assert {:error, %Ecto.Changeset{}} = UserDatastore.create_or_update(@invalid_attrs)
    end
  end
end
