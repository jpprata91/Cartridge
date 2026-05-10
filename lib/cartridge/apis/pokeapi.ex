defmodule Cartridge.Api.Pokeapi do
  alias Cartridge.Http

  def get_pokemon(query) do
    query =
      query
      |> String.trim()
      |> String.downcase()
      |> URI.encode_www_form()

    url = "https://pokeapi.co/api/v2/pokemon/#{query}"
    Http.get_json(url)
  end
end