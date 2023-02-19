defmodule ChatWeb.PageController do
  use ChatWeb, :controller
  require Logger
  def index(conn, _params) do
    render(conn, "index.html")
  end

  def regulamin(conn, _params) do
    render(conn, "rules.html")
  end

  def update(conn, %{
    "oldusername" => oldusername,
    "username" => username,
    "id" => id,
    "avatar" => avatar,
    "roomid" => roomid,
  }) do
    ChatWeb.Presence.update(self(), roomid, id, %{username: username, updated: "true", avatar: avatar})


    conn
    |> put_session(:username, username)
    |> put_session(:avatar, avatar)
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Poison.encode!(%{username: username, avatar: avatar}))
  end


  def upload(conn, %{"file" => file, "username" => username, "roomid" => roomid}) do
    ChatWeb.Endpoint.broadcast("#{roomid}", "new_message", %{
      uuid: UUID.uuid4(),
      content: file,
      username: "#{username}"
    })


    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Poison.encode!(%{file: file}))
  end



end
