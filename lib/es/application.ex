defmodule Es.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Es.Repo,
      # Start the Telemetry supervisor
      EsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Es.PubSub},
      # Start the Endpoint (http/https)
      EsWeb.Endpoint
      # Start a worker by calling: Es.Worker.start_link(arg)
      # {Es.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Es.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
