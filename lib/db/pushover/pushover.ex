defmodule Db.Pushover do
  @moduledoc """
  Pushover
  """

  @missing_token_or_user_error_message """
  To authenticated with Pushover you need to provide valid a user and 
  an application token. Please include them in your environment config.

  PUSHOVER_USER=<string>
  PUSHOVER_TOKEN=<string>
  """

  def get_user do
    Application.get_env(:db, :user) ||
      raise @missing_token_or_user_error_message
  end

  def get_token do
    Application.get_env(:db, :token) ||
      raise @missing_token_or_user_error_message
  end
end
