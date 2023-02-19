defmodule ChatWeb.PageLive do
  use ChatWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    random_slug = "/rooms/" <> MnemonicSlugs.generate_slug(3)



    {:ok, assign(socket, random_slug: random_slug)}
  end

end
