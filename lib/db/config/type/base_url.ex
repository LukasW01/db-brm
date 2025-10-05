defmodule Db.Config.Type.BaseUrl do
  @moduledoc """
  Type definition: Base URL
  """
  use Skogsra.Type

  @impl Skogsra.Type
  def cast(value)

  def cast(value) when is_binary(value) do
    case String.match?(value, ~r/^(?:htt(?:ps|p):\/\/)(?=(.+\..{3,}))/) do
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
