defmodule Datastore.UserDatastore.UserData do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_data" do
    field :payload, :string
    field :service_slug, :string
    field :user_identifier, Ecto.UUID

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(user_data, attrs) do
    user_data
    |> cast(attrs, [:user_identifier, :payload, :service_slug])
    |> validate_required([:user_identifier, :service_slug])
  end
end
