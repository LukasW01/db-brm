defmodule Db.Pushover.Messages do
  @moduledoc """
  API calls for Pushover Message API
  """

  @doc """
  Sends a message via Pushover

  ## Parameters

  *   `message` (*type:* `Db.Pushover.Model.Message`) - the message to send.

  ## Returns
  *   `{:ok, %{}}` on success
  *   `{:error, info}` on failure
  """
  @spec send(Db.Pushover.Model.Message.t()) ::
          {:ok, Req.Response.t()} | {:error, Exception.t()}
  def send(message) do
    Req.post!("https://api.pushover.net/1/messages.json",
      json: %{
        message
        | user: Application.get_env(:db, :user),
          token: Application.get_env(:db, :token)
      }
    )
  end
end
