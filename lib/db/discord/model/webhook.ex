defmodule Db.Discord.Model.Webhook do
  @moduledoc """
  Represents the payload structure for a Discord webhook message.

  This model can be serialized and sent to a Discord webhook endpoint using `POST`.

  ## Attributes

  *   `username` (*type:* `String.t`, *default:* `nil`) - The username to override the default webhook username.
  *   `avatar_url` (*type:* `String.t`, *default:* `nil`) - The URL of the avatar image to override the default webhook avatar.
  *   `content` (*type:* `String.t`, *default:* `nil`) - The plain text message content (up to 2000 characters).
  *   `embeds` (*type:* `list(Db.Discord.Model.Embed.t)`, *default:* `[]`) - A list of rich embed objects.

  Only one of `:content` or `:embeds` is required.
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
  @moduledoc """
  A Discord embed object that provides rich formatting for messages.

  Embeds can include structured fields, images, authors, and more.

  ## Attributes

  *   `author` (*type:* `Db.Discord.Model.EmbedAuthor.t`, *default:* `nil`) - An optional author block.
  *   `title` (*type:* `String.t`, *default:* `nil`) - Optional title of the embed.
  *   `url` (*type:* `String.t`, *default:* `nil`) - URL that turns the title into a hyperlink.
  *   `description` (*type:* `String.t`, *default:* `nil`) - Description text, supports Markdown.
  *   `color` (*type:* `integer()`, *default:* `nil`) - Optional color code for the embed's left border.
  *   `fields` (*type:* `list(Db.Discord.Model.EmbedField.t)`, *default:* `[]`) - A list of embed fields.
  *   `thumbnail` (*type:* `Db.Discord.Model.EmbedMedia.t`, *default:* `nil`) - Thumbnail image.
  *   `image` (*type:* `Db.Discord.Model.EmbedMedia.t`, *default:* `nil`) - Main image.
  *   `footer` (*type:* `Db.Discord.Model.EmbedFooter.t`, *default:* `nil`) - Optional footer block.

  Refer to the [Discord embed documentation](https://discord.com/developers/docs/resources/webhook#execute-webhook) for limitations.
  """

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
  @moduledoc """
  Represents the author block inside an embed.

  Displayed at the top of the embed with an optional icon and URL.

  ## Attributes

  *   `name` (*type:* `String.t`, *default:* `nil`) - The name of the author.
  *   `url` (*type:* `String.t`, *default:* `nil`) - Optional URL that the author's name links to.
  *   `icon_url` (*type:* `String.t`, *default:* `nil`) - Optional icon shown to the left of the author's name.
  """

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
  @moduledoc """
  Represents the footer block for a Discord embed.

  Appears at the bottom of the embed with optional icon.

  ## Attributes

  *   `text` (*type:* `String.t`, *default:* `nil`) - Footer text.
  *   `icon_url` (*type:* `String.t`, *default:* `nil`) - Optional icon shown to the left of the text.
  """

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
  @moduledoc """
  A field block used within Discord embeds.

  Useful for listing key-value pairs or tabular-style data.

  ## Attributes

  *   `name` (*type:* `String.t`, *default:* `nil`) - The name or title of the field (bold by default).
  *   `value` (*type:* `String.t`, *default:* `nil`) - The value of the field (supports Markdown).
  *   `inline` (*type:* `boolean()`, *default:* `false`) - Whether the field should be displayed inline.
  """

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
  @moduledoc """
  Represents an image or thumbnail in an embed.

  Used for the `:image` or `:thumbnail` fields.

  ## Attributes

  *   `url` (*type:* `String.t`, *default:* `nil`) - The URL of the image to display.
  """

  @type t :: %__MODULE__{
          url: String.t()
        }

  @derive Jason.Encoder
  defstruct [
    :url
  ]
end
