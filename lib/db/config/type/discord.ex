defmodule Db.Config.Type.Discord do
  @moduledoc """
  Type definition: Discord
  """
  use Skogsra.Type

  @impl Skogsra.Type
  def cast(value)

  def cast(value) when is_binary(value) do
    case String.match?(value, ~r/https:\/\/discord.com\/api\/webhooks\/([^\/]+)\/([^\/]+)/) do
      true ->
        {:ok, value}

      false ->
        :error
    end
  end

  def cast(_) do
    :error
  end
end
