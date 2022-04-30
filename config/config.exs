# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bulletin_board,
  ecto_repos: [BulletinBoard.Repo]

# Configures the endpoint
config :bulletin_board, BulletinBoardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2+oLwepfYy3tlSSvL4TdBEb7Ti1kkN1h0ZkXU9kXL34lbBUReRA4w2EMypNa++uh",
  render_errors: [view: BulletinBoardWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BulletinBoard.PubSub,
  live_view: [signing_salt: "cW2ILpmC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
