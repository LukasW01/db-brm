defmodule Db.Pushover.Api.Messages do
  @moduledoc """
  API calls for Pushover Message API
  """

  alias Db.Pushover.Connection
  alias Db.Pushover.Params
  alias GoogleApi.Gax.{Request, Response}

  @doc """
  Sends a message via Pushover

  ## Parameters

  *   `message` (*type:* `Pushover.Model.Message`) - the message to send.
  *   `connection` (*type:* `Pushover.Connection.t`) - Connection to server

  ## Returns
  *   `{:ok, %{}}` on success
  *   `{:error, info}` on failure
  """
  @spec send(Db.Pushover.Model.Message.t()) ::
          {:ok, Db.Pushover.Model.MessageResponse.t()} | {:error, Tesla.Env.t()}
  def send(message) do
    request =
      Request.new()
      |> Request.method(:post)
      |> Request.url("/messages.json")
      |> Request.add_param(:query, :token, Db.Pushover.get_token())
      |> Request.add_param(:query, :user, Db.Pushover.get_user())
      |> Request.add_param(:body, :message, message.data)
      |> Request.add_optional_params(
        Params.get_optional_params(),
        Params.optional_params(message)
      )

    Connection.new()
    |> Connection.execute(request)
    |> Response.decode(struct: %Db.Pushover.Model.MessageResponse{})
  end
end
