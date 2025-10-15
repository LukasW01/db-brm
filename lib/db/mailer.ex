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
    # Start an asynchronous process to deliver mail in parallel
    Task.start(fn ->
      case deliver(email) do
        {:error, reason} ->
          Logger.warning("Mailer backend failed with: #{inspect(reason)}")

        {:ok, response} ->
          {:ok, response}
      end
    end)
  end
end
