defmodule Datastore.UserDatastore do
  @moduledoc """
  The UserDatastore context.
  """

  import Ecto.Query, warn: false
  alias Datastore.Repo

  alias Datastore.UserDatastore.UserData

  def store_size do
    Repo.aggregate(UserData, :count)
  end

  def get_user_data(user_identifier, service_slug) do
    Repo.get_by(
      UserData,
      user_identifier: user_identifier,
      service_slug: service_slug
    )
  end

  def create_or_update(attrs \\ %{}) do
    user_data = if attrs[:user_identifier] && attrs[:service_slug] do
      get_user_data(attrs[:user_identifier], attrs[:service_slug])
    end

    case user_data do
      nil -> create_user_data(attrs)
      user_data -> update_user_data(user_data, attrs)
    end
  end

  @doc """
  Creates a user_data.

  ## Examples

      iex> create_user_data(%{field: value})
      {:ok, %UserData{}}

      iex> create_user_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_data(attrs \\ %{}) do
    %UserData{}
    |> UserData.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_data.

  ## Examples

      iex> update_user_data(user_data, %{field: new_value})
      {:ok, %UserData{}}

      iex> update_user_data(user_data, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_data(%UserData{} = user_data, attrs) do
    user_data
    |> UserData.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_data changes.

  ## Examples

      iex> change_user_data(user_data)
      %Ecto.Changeset{data: %UserData{}}

  """
  def change_user_data(%UserData{} = user_data, attrs \\ %{}) do
    UserData.changeset(user_data, attrs)
  end
end
