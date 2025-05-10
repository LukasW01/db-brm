defmodule Db.Discord do
  @moduledoc """
  Discord (webhook)
  """

  @missing_webhook_error_message """
  To send a webhook via Discord you need a valid URL. 
  Please include them in your environment config.

  DISCORD_WEBHOOK=https://discord.com/api/webhooks/123/123
  """

  def get_webhook do
    case Application.get_env(:db, :webhook_url) do
      url when is_binary(url) ->
        if Regex.match?(url, ~r/https:\/\/discord\.com\/api\/webhooks\/([^\/]+)\/([^\/]+)/),
          do: url,
          else: {:error, @missing_webhook_error_message}

      _ ->
        {:error, @missing_webhook_error_message}
    end
  end
end
