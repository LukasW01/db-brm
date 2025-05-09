defmodule Db.Discord.Model.Webhook do
  @moduledoc """
  Discord webhook payload model.
  """

  @type t :: %__MODULE__{
          username: String.t() | nil,
          avatar_url: String.t() | nil,
          content: String.t() | nil,
          embeds: list(Db.Discord.Model.Embed.t()) | nil
        }

  @derive Jason.Encoder
  defstruct [
    :username,
    :avatar_url,
    :content,
    :embeds
  ]
end

defmodule Db.Discord.Model.Embed do
  @moduledoc "A Discord embed object"

  @type t :: %__MODULE__{
          author: Db.Discord.Model.EmbedAuthor.t() | nil,
          title: String.t() | nil,
          url: String.t() | nil,
          description: String.t() | nil,
          color: integer() | nil,
          fields: list(Db.Discord.Model.EmbedField.t()) | nil,
          thumbnail: Db.Discord.Model.EmbedMedia.t() | nil,
          image: Db.Discord.Model.EmbedMedia.t() | nil,
          footer: Db.Discord.Model.EmbedFooter.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :author,
    :title,
    :url,
    :description,
    :color,
    :fields,
    :thumbnail,
    :image,
    :footer
  ]
end

defmodule Db.Discord.Model.EmbedAuthor do
  @moduledoc "Author block for Discord embed"

  @type t :: %__MODULE__{
          name: String.t() | nil,
          url: String.t() | nil,
          icon_url: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :name,
    :url,
    :icon_url
  ]
end

defmodule Db.Discord.Model.EmbedFooter do
  @moduledoc "Footer block for Discord embed"

  @type t :: %__MODULE__{
          text: String.t() | nil,
          icon_url: String.t() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :text,
    :icon_url
  ]
end

defmodule Db.Discord.Model.EmbedField do
  @moduledoc "Field block for Discord embed"

  @type t :: %__MODULE__{
          name: String.t(),
          value: String.t(),
          inline: boolean() | nil
        }

  @derive Jason.Encoder
  defstruct [
    :name,
    :value,
    :inline
  ]
end

defmodule Db.Discord.Model.EmbedMedia do
  @moduledoc "Image or thumbnail block for Discord embed"

  @type t :: %__MODULE__{
          url: String.t()
        }

  @derive Jason.Encoder
  defstruct [
    :url
  ]
end
