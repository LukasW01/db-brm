defmodule Db.Config.Type.Key do
  @moduledoc """
  Type definition: Encryption-Key
  """
  use Skogsra.Type

  @impl Skogsra.Type
  def cast(value)

  def cast(value) when is_binary(value) do
    if String.length(value) == 32 do
      {:ok, value}
    else
      :error
    end
  end

  def cast(_) do
    :error
  end
end
