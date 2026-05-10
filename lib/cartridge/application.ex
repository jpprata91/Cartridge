defmodule Cartridge.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Cartridge.Store,
      Cartridge.Consumer
    ]

    opts = [strategy: :one_for_one, name: Cartridge.Supervisor]
    Supervisor.start_link(children, opts)
  end
end