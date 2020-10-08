defmodule Datastore.Repo.Migrations.CreateUserData do
  use Ecto.Migration

  def change do
    create table(:user_data, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_identifier, :uuid
      add :payload, :string
      add :service_slug, :string

      timestamps(inserted_at: :created_at)
    end

    create unique_index(
      :user_data,
      [:service_slug, :user_identifier],
      name: :index_user_data_on_service_slug_and_user_identifier
    )
  end
end
