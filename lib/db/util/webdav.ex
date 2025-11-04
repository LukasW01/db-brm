defmodule Db.Webdav do
  @moduledoc """
  Provides configuration for connecting to a WebDAV server.

  `config/0` function that builds and returns a `Webdavex.Config` struct containing the base URL and authentication headers
  required to interact with the WebDAV server.

  ## Example

      iex> config = Db.Webdav.config()
      %Webdavex.Config{
        base_url: "http://myhost.com",
        headers: [{"Authorization", "Basic abc"}]
      }

  ## Usage
    
      iex> Db.Webdav.config() |> Webdavex.Client.get("image.png")
  """
  @spec config() :: Webdavex.Config.t()
  def config do
    Webdavex.Config.new(
      base_url: URI.parse(Application.get_env(:db, :webdav_url)),
      headers: [
        {"Authorization",
         "Basic " <>
           :base64.encode(
             Application.get_env(:db, :webdav_user) <> ":" <> Application.get_env(:db, :webdav_pw)
           )}
      ]
    )
  end
end
