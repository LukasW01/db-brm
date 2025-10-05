defmodule Db.Config.Type.Mail do
  @moduledoc """
  Type definition: Mail
  """
  use Skogsra.Type

  @impl Skogsra.Type
  def cast(value)

  def cast(value) when is_binary(value) do
    case String.match?(value, ~r/^\S+@\S+\.\S+$/) do
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
