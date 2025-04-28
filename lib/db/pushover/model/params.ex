defmodule Db.Pushover.Params do
  @moduledoc """
  Optional params (& Keyword filtering)
  """
  def get_optional_params,
    do: %{
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

  def optional_params(message) do
    Keyword.new(
      Enum.filter(Map.keys(message), fn x ->
        Enum.member?(Map.keys(get_optional_params()), x)
      end),
      fn x -> {x, Map.fetch!(message, x)} end
    )
  end
end
