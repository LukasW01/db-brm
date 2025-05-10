defmodule Db.Discord.Model.Webhooks do
  @moduledoc """
  API calls for Discord Webhook API
  """

  alias Db.Discord

  @doc """
  Sends a Webhook to a Discord Channel

  ## Parameters

  *   `message` (*type:* `Db.Discord.Model.Webhook`) - the message to send.

  ## Returns
  *   `{:ok, Req.Response.t()}` on success
  *   `{:error, Exception.t()}` on failure
  """
  @spec send(Db.Discord.Model.Webhook.t()) ::
          {:ok, Req.Response.t()} | {:error, Exception.t()}
  def send(message) do
    Req.post!(url: Discord.get_webhook(), json: message)
  end
end
