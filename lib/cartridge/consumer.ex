defmodule Cartridge.Consumer do
  use Nostrum.Consumer

  alias Nostrum.Api
  alias Cartridge.Commands

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    handle_message(msg)
  end

  def handle_event(_event), do: :noop

  defp handle_message(%{author: %{bot: true}}), do: :ignore

  defp handle_message(%{content: "!ping", channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.ping())
  end

  defp handle_message(%{content: "!pokemon " <> query, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.pokemon(query))
  end

  defp handle_message(%{content: "!nintendogame " <> args, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.nintendogame(args))
  end

  defp handle_message(%{content: "!clima " <> city, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.clima(city))
  end

  defp handle_message(%{content: "!conv " <> args, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.conv(args))
  end

  defp handle_message(%{content: "!lembrar " <> text, author: %{id: user_id}, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.lembrar(user_id, text))
  end

  defp handle_message(%{content: "!lembretes", author: %{id: user_id}, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.lembretes(user_id))
  end

  defp handle_message(%{content: "!curiosidade " <> city, channel_id: channel_id}) do
    Api.create_message(channel_id, Commands.curiosidade(city))
  end

  defp handle_message(_msg), do: :ignore
end