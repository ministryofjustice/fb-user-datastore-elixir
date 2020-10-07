defmodule Datastore.UserDatastoreTest do
  use Datastore.DataCase

  alias Datastore.UserDatastore

  describe "user_data" do
    alias Datastore.UserDatastore.UserData

    @valid_attrs %{created_at: ~N[2010-04-17 14:00:00], payload: "some payload", service_slug: "some service_slug", updated_at: ~N[2010-04-17 14:00:00], user_identifier: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{created_at: ~N[2011-05-18 15:01:01], payload: "some updated payload", service_slug: "some updated service_slug", updated_at: ~N[2011-05-18 15:01:01], user_identifier: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{created_at: nil, payload: nil, service_slug: nil, updated_at: nil, user_identifier: nil}

    def user_data_fixture(attrs \\ %{}) do
      {:ok, user_data} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserDatastore.create_user_data()

      user_data
    end

    test "list_user_data/0 returns all user_data" do
      user_data = user_data_fixture()
      assert UserDatastore.list_user_data() == [user_data]
    end

    test "get_user_data!/1 returns the user_data with given id" do
      user_data = user_data_fixture()
      assert UserDatastore.get_user_data!(user_data.id) == user_data
    end

    test "create_user_data/1 with valid data creates a user_data" do
      assert {:ok, %UserData{} = user_data} = UserDatastore.create_user_data(@valid_attrs)
      assert user_data.created_at == ~N[2010-04-17 14:00:00]
      assert user_data.payload == "some payload"
      assert user_data.service_slug == "some service_slug"
      assert user_data.updated_at == ~N[2010-04-17 14:00:00]
      assert user_data.user_identifier == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_user_data/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserDatastore.create_user_data(@invalid_attrs)
    end

    test "update_user_data/2 with valid data updates the user_data" do
      user_data = user_data_fixture()
      assert {:ok, %UserData{} = user_data} = UserDatastore.update_user_data(user_data, @update_attrs)
      assert user_data.created_at == ~N[2011-05-18 15:01:01]
      assert user_data.payload == "some updated payload"
      assert user_data.service_slug == "some updated service_slug"
      assert user_data.updated_at == ~N[2011-05-18 15:01:01]
      assert user_data.user_identifier == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_user_data/2 with invalid data returns error changeset" do
      user_data = user_data_fixture()
      assert {:error, %Ecto.Changeset{}} = UserDatastore.update_user_data(user_data, @invalid_attrs)
      assert user_data == UserDatastore.get_user_data!(user_data.id)
    end

    test "delete_user_data/1 deletes the user_data" do
      user_data = user_data_fixture()
      assert {:ok, %UserData{}} = UserDatastore.delete_user_data(user_data)
      assert_raise Ecto.NoResultsError, fn -> UserDatastore.get_user_data!(user_data.id) end
    end

    test "change_user_data/1 returns a user_data changeset" do
      user_data = user_data_fixture()
      assert %Ecto.Changeset{} = UserDatastore.change_user_data(user_data)
    end
  end
end
