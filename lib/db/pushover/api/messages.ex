defmodule Db.Pushover.Api.Messages do
  @moduledoc """
  API calls for Pushover Message API
  """

  alias Db.Pushover.Connection
  alias GoogleApi.Gax.{Request, Response}

  @params %{
    :device => :query,
    :title => :body,
    :url => :query,
    :url_title => :query,
    :priority => :query,
    :retry => :query,
    :expire => :query,
    :sound => :query,
    :timestamp => :query
  }

  @doc """
  Sends a message via Pushover

  ## Parameters

  *   `message` (*type:* `Pushover.Model.Message`) - the message to send.

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
        @params,
        message
        |> Map.from_struct()
        |> Enum.filter(fn {k, v} -> Map.has_key?(@params, k) and not is_nil(v) end)
      )

    Connection.new()
    |> Connection.execute(request)
    |> Response.decode(struct: %Db.Pushover.Model.MessageResponse{})
  end
end
