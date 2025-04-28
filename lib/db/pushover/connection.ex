defmodule Db.Pushover.Connection do
  @moduledoc """
  Handle Tesla connections for Pushover.
  """

  @type t :: Tesla.Env.client()

  use GoogleApi.Gax.Connection,
    otp_app: :db,
    base_url: "https://api.pushover.net/1"
end
