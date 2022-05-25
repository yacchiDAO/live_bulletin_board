defmodule BulletinBoard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BulletinBoard.Repo,
      # Start the Telemetry supervisor
      BulletinBoardWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BulletinBoard.PubSub},
      # It must be after the PubSub child and before the endpoint:
      BulletinBoardWeb.Presence,
      # Start the Endpoint (http/https)
      BulletinBoardWeb.Endpoint
      # Start a worker by calling: BulletinBoard.Worker.start_link(arg)
      # {BulletinBoard.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BulletinBoard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BulletinBoardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
