# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :datastore,
  ecto_repos: [Datastore.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :datastore, DatastoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QBhGZ2MMwr+BueMpGWoqiZOxDvlfxlqrS70omkSWOJUAiZHcutB6N8ufoVQGq3Zm",
  render_errors: [view: DatastoreWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Datastore.PubSub,
  live_view: [signing_salt: "K2w5IloQ"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
