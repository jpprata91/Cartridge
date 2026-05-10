defmodule Cartridge.Store do
  use GenServer

  @file_path "data/memories.json"

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def remember(user_id, text) do
    GenServer.call(__MODULE__, {:remember, to_string(user_id), text})
  end

  def list(user_id) do
    GenServer.call(__MODULE__, {:list, to_string(user_id)})
  end

  @impl true
  def init(_state) do
    {:ok, load_file()}
  end

  @impl true
  def handle_call({:remember, user_id, text}, _from, state) do
    updated =
      Map.update(state, user_id, [text], fn notes ->
        [text | notes]
      end)

    save_file(updated)
    {:reply, :ok, updated}
  end

  @impl true
  def handle_call({:list, user_id}, _from, state) do
    notes = Map.get(state, user_id, [])
    {:reply, Enum.reverse(notes), state}
  end

  defp load_file do
    ensure_file_exists()

    @file_path
    |> File.read()
    |> case do
      {:ok, content} ->
        case Jason.decode(content) do
          {:ok, map} when is_map(map) -> map
          _ -> %{}
        end

      _ ->
        %{}
    end
  end

  defp save_file(state) do
    ensure_dir_exists()

    json =
      state
      |> Jason.encode!(pretty: true)

    File.write!(@file_path, json)
  end

  defp ensure_file_exists do
    ensure_dir_exists()

    if not File.exists?(@file_path) do
      File.write!(@file_path, "{}")
    end
  end

  defp ensure_dir_exists do
    File.mkdir_p!("data")
  end
end