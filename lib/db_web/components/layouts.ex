defmodule DbWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use DbWeb, :controller` and
  `use DbWeb, :live_view`.
  """
  use DbWeb, :html
  import DbWeb.CoreComponents
  import DbWeb.SvgComponents

  embed_templates "layouts/*"
end
