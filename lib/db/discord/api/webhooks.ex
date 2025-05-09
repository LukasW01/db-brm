defmodule Db.Discord.Model.Webhooks do
  @moduledoc """
  API calls for Pushover Message API
  """

  alias Db.Discord

  @doc """
  Sends a message via Pushover

  ## Parameters

  *   `message` (*type:* `Pushover.Model.Message`) - the message to send.

  ## Returns
  *   `{:ok, %{}}` on success
  *   `{:error, info}` on failure
  """
  @spec send(Db.Discord.Model.Webhook.t()) ::
          {:ok, Req.Response.t()} | {:error, Exception.t()}
  def send(message) do
    Req.post!(url: Discord.get_webhook(), json: message)
  end
end
