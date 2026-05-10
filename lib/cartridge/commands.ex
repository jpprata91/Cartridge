defmodule Cartridge.Commands do
  alias Cartridge.Api.ExchangeRate
  alias Cartridge.Api.Geocoding
  alias Cartridge.Api.Nintendo
  alias Cartridge.Api.Pokeapi
  alias Cartridge.Api.Weather
  alias Cartridge.Api.Wikipedia
  alias Cartridge.Store

  def ping do
    "Pong!"
  end

  def pokemon(query) do
    case Pokeapi.get_pokemon(query) do
      {:ok, pokemon} -> format_pokemon(pokemon)
      {:error, _} -> "Pokémon não encontrado."
    end
  end

  def nintendogame(args) do
    case String.split(String.trim(args), ~r/\s+/, parts: 2) do
      [console, "random"] ->
        case Nintendo.get_games(console) do
          {:ok, []} -> "Não achei jogos para esse console."
          {:ok, games} -> format_game(Enum.random(games))
          {:error, reason} -> "Erro ao buscar jogos: #{inspect(reason)}"
        end

      [console, index_text] ->
        case Integer.parse(index_text) do
          {index, ""} ->
            case Nintendo.get_games(console) do
              {:ok, []} ->
                "Não achei jogos para esse console."

              {:ok, games} ->
                game = Enum.at(games, index - 1)

                if game do
                  format_game(game)
                else
                  "Índice inválido para esse console."
                end

              {:error, reason} ->
                "Erro ao buscar jogos: #{inspect(reason)}"
            end

          _ ->
            "Uso: !nintendogame SNES random ou !nintendogame SNES 1100"
        end

      _ ->
        "Uso: !nintendogame SNES random ou !nintendogame SNES 1100"
    end
  end

  def clima(city) do
    case Weather.get_by_city(city) do
      {:ok, weather} -> format_weather(weather)
      {:error, _} -> "Não consegui buscar o clima dessa cidade."
    end
  end

  def conv(args) do
  case String.split(String.trim(args), ~r/\s+/) do
    [amount_text, from, to] ->
      with {amount, _} <- Float.parse(amount_text),
           {:ok, result} <- Cartridge.Api.ExchangeRate.convert(amount, from, to) do
        "#{amount} #{String.upcase(from)} = #{result} #{String.upcase(to)}"
      else
        {:error, :currency_not_supported} -> "Moeda não suportada ou par inválido."
        _ -> "Erro ao converter. Verifique se o valor é numérico (ex: 100.50)."
      end

    _ -> "Uso: !conv 100 USD BRL"
  end
  end

  def lembrar(user_id, text) do
    :ok = Store.remember(user_id, text)
    "Anotado! Vou me lembrar disso."
  end

  def lembretes(user_id) do
    notes = Store.list(user_id)

    case notes do
      [] -> "Você ainda não salvou nenhum lembrete."
      _ -> "Suas anotações:\n- " <> Enum.join(notes, "\n- ")
    end
  end

  def curiosidade(city) do
    with {:ok, place} <- Geocoding.search_city(city),
         {:ok, summary} <- Wikipedia.summary(place) do
      """
      Cidade: #{place["name"]}
      País: #{place["country"]}
      Curiosidade: #{summary}
      """
    else
      _ -> "Não consegui montar a curiosidade dessa cidade."
    end
  end

  defp format_pokemon(pokemon) do
    types =
      pokemon["types"]
      |> Enum.map(fn item -> item["type"]["name"] end)
      |> Enum.join(", ")

    """
    Pokémon: #{String.capitalize(pokemon["name"])}
    Nº: #{pokemon["id"]}
    Tipos: #{types}
    Peso: #{pokemon["weight"]}
    Altura: #{pokemon["height"]}
    """
  end

  defp format_game(game) do
    """
    Jogo: #{game["name"]}
    Lançamento: #{game["release_date"] || "desconhecido"}
    """
  end

  defp format_weather(weather) do
    """
    Cidade: #{weather["city"]}
    Temperatura: #{weather["temperature"]}°C
    Vento: #{weather["wind_speed"]} km/h
    """
  end
end