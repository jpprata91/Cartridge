defmodule Cartridge.Api.Weather do
  alias Cartridge.Http

  def get_by_city(city) do
    with {:ok, place} <- geocode(city),
         {:ok, weather} <- current_weather(place) do
      {:ok,
       %{
         "city" => place["name"],
         "temperature" => weather["current"]["temperature_2m"],
         "wind_speed" => weather["current"]["wind_speed_10m"]
       }}
    end
  end

  defp geocode(city) do
    url =
      "https://geocoding-api.open-meteo.com/v1/search?name=#{URI.encode_www_form(city)}&count=1&language=pt&format=json"

    with {:ok, body} <- Http.get_json(url),
         [first | _] <- body["results"] do
      {:ok, first}
    else
      _ -> {:error, :not_found}
    end
  end

  defp current_weather(place) do
    lat = place["latitude"]
    lon = place["longitude"]

    url =
      "https://api.open-meteo.com/v1/forecast?latitude=#{lat}&longitude=#{lon}&current=temperature_2m,wind_speed_10m&timezone=auto"

    Http.get_json(url)
  end
end