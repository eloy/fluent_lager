defmodule FluentLager.EventHandler do
  use GenEvent
  alias FluentLager.Fluent

  def init(level) do
    {:ok, {}}
  end


  def handle_call(:get_loglevel, state) do
    {:ok, [], state}
  end

  def handle_call({:set_loglevel, level}, state) do
    {:ok, :ok, state}
  end

  def handle_event({:log, message}, state) do
    Fluent.log(message)
    {:ok, state}
  end
end
