defmodule Db.Config.Type.Url do
  @moduledoc """
  Type definition: URL
  """
  use Skogsra.Type

  @impl Skogsra.Type
  def cast(value)

  def cast(value) when is_binary(value) do
    case String.match?(
           value,
           ~r/^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$/
         ) do
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
