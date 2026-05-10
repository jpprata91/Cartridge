defmodule Cartridge.Api.Wikipedia do
  alias Cartridge.Http

  def summary(place) do
    title =
      place["name"]
      |> String.trim()
      |> URI.encode_www_form()

    url = "https://pt.wikipedia.org/api/rest_v1/page/summary/#{title}"

    with {:ok, body} <- Http.get_json(url),
         summary when is_binary(summary) <- body["extract"] do
      {:ok, summary}
    else
      _ -> {:error, :not_found}
    end
  end
end