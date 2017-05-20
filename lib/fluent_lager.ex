defmodule FluentLager do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    add_event_handler()

    children = [
      worker(FluentLager.Fluent, [])
    ]

    opts = [strategy: :one_for_one, name: FluentLager.Supervisor]
    Supervisor.start_link(children, opts)
  end


  defp add_event_handler do
    if Application.get_env(:fluent_lager, :tag) != nil do
      GenEvent.add_handler(:lager_event, FluentLager.EventHandler, [])
    end
  end
end
