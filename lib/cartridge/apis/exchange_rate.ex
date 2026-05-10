defmodule Cartridge.Api.ExchangeRate do
  alias Cartridge.Http

  def convert(amount, from, to) do
    from = String.upcase(from)
    to = String.upcase(to)

    if from == to do
      {:ok, Float.round(amount / 1, 2)}
    else
      url = "https://economia.awesomeapi.com.br/json/last/#{from}-#{to}"

      case Http.get_json(url) do
        {:ok, body} ->
          pair = "#{from}#{to}"
          
          if data = body[pair] do
            {rate, _} = Float.parse(data["bid"])
            result = amount * rate
            {:ok, Float.round(result, 2)}
          else
            {:error, :currency_not_supported}
          end

        {:error, _} ->
          {:error, :service_unavailable}
      end
    end
  end
end