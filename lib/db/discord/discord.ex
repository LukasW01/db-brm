defmodule Db.Discord do
  @moduledoc """
  Pushover
  """

  @missing_webhook_error_message """
  To send a webhook via Discord you need a valid URL. 
  Please include them in your environment config file.

  DISCORD_WEBHOOK=<string>
  """

  def get_webhook do
    Application.get_env(:db, :webhook_url) ||
      raise message: @missing_webhook_error_message
  end
end
