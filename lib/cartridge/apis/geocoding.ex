defmodule Cartridge.Api.Geocoding do
  alias Cartridge.Http

  def search_city(city) do
    url =
      "https://geocoding-api.open-meteo.com/v1/search?name=#{URI.encode_www_form(city)}&count=1&language=pt&format=json"

    with {:ok, body} <- Http.get_json(url),
         [first | _] <- body["results"] do
      {:ok, first}
    else
      _ -> {:error, :not_found}
    end
  end
end