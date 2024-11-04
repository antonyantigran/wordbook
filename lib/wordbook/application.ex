defmodule Wordbook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WordbookWeb.Telemetry,
      Wordbook.Repo,
      {DNSCluster, query: Application.get_env(:wordbook, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Wordbook.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Wordbook.Finch},
      # Start a worker by calling: Wordbook.Worker.start_link(arg)
      # {Wordbook.Worker, arg},
      # Start to serve requests, typically the last entry
      WordbookWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wordbook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WordbookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
