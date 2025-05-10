defmodule Db.Pushover.Messages do
  @moduledoc """
  API calls for Pushover Message API
  """

  alias Db.Pushover

  @doc """
  Sends a message via Pushover

  ## Parameters

  *   `message` (*type:* `Pushover.Model.Message`) - the message to send.

  ## Returns
  *   `{:ok, %{}}` on success
  *   `{:error, info}` on failure
  """
  @spec send(Db.Pushover.Model.Message.t()) ::
          {:ok, Req.Response.t()} | {:error, Exception.t()}
  def send(message) do
    Req.post!("https://api.pushover.net/1/messages.json",
      json: %{message | user: Pushover.get_user(), token: Pushover.get_token()}
    )
  end
end
