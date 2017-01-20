defmodule FluentLager do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    GenEvent.add_handler(:lager_event, FluentLager.EventHandler, [])
    children = [
      worker(FluentLager.Fluent, [])
    ]

    opts = [strategy: :one_for_one, name: FluentLager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
