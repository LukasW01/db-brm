defmodule Db.Config.Type.Mailgun do
  @moduledoc """
  Type definition: Mailgun
  """
  use Skogsra.Type

  @impl Skogsra.Type
  def cast(value)

  def cast(value) when is_binary(value) do
    case String.match?(value, ~r/https:\/\/api\.(?:eu\.)?mailgun\.net/) do
      true ->
        {:ok, value}

      false ->
        :error
    end
  end

  def cast(_) do
    :error
  end
end
