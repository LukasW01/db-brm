defmodule Db.Mailer do
  use Swoosh.Mailer, otp_app: :db
  import Swoosh.Email

  require Logger

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    %Swoosh.Email{}
    |> to({"", user.email})
    |> from({"DB", Application.get_env(:db, Db.Mailer)[:from]})
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end

  def process(email) do
    # An asynchronous process should be used here to prevent enumeration
    # attacks. Synchronous e-mail delivery can reveal whether a user already
    # exists in the system or not.
    Task.start(fn ->
      case deliver(email) do
        {:error, reason} ->
          Logger.warning("Mailer backend failed with: #{inspect(reason)}")

        {:ok, response} ->
          {:ok, response}
      end
    end)

    :ok
  end
end
