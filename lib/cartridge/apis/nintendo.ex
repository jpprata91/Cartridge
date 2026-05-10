defmodule Cartridge.Api.Nintendo do
  alias Cartridge.Http

  @base_url "https://api.thegamesdb.net"

  def get_games(console) do
    with {:ok, platform_id} <- platform_id(console),
         {:ok, body} <- fetch_games(platform_id),
         {:ok, games} <- extract_games(body) do
      {:ok, games}
    end
  end

  defp platform_id(console) do
    case String.upcase(String.trim(console)) do
      "SNES" -> {:ok, 6}
      "SUPER NINTENDO" -> {:ok, 6}
      "NES" -> {:ok, 7}
      _ -> {:error, :unknown_console}
    end
  end

  defp fetch_games(platform_id) do
    api_key = Application.get_env(:cartridge, :gamesdb_api_key)

    if is_nil(api_key) or api_key == "" do
      {:error, :missing_api_key}
    else
      # Se a tua conta/docs usar outro nome de parâmetro, ajuste só esta URL.
      url =
        "#{@base_url}/v1/Games/ByPlatformID?apikey=#{api_key}&id=#{platform_id}"

      Http.get_json(url)
    end
  end

  defp extract_games(body) do
    games =
      get_in(body, ["data", "games"]) ||
        body["data"] && body["data"]["games"] ||
        []

    normalized =
      games
      |> Enum.map(fn game ->
        %{
          "name" => game["game_title"] || game["name"] || "Sem nome",
          "release_date" => game["release_date"],
          "id" => game["id"]
        }
      end)

    {:ok, normalized}
  end
end