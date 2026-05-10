defmodule Cartridge.Http do
  @moduledoc false

  def get_json(url, headers \\ []) do
    case HTTPoison.get(url, headers, recv_timeout: 15_000) do
      {:ok, %HTTPoison.Response{status_code: code, body: body}} when code in 200..299 ->
        Jason.decode(body)

      {:ok, %HTTPoison.Response{status_code: code, body: body}} ->
        {:error, {code, body}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end