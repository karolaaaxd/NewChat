defmodule ChatWeb.RoomLive do
  use ChatWeb, :live_view
  require Logger
  @impl true
  def mount(%{"id" => room_id}, session, socket) do
    username = session["username"] || MnemonicSlugs.generate_slug(2)
    topic = room_id
    avatar = session["avatar"] || "ghost"

    channel1 = "#{MnemonicSlugs.generate_slug(3)}"
    channel2 = "#{MnemonicSlugs.generate_slug(3)}"
    channel3 = "#{MnemonicSlugs.generate_slug(3)}"
    channel4 = "#{MnemonicSlugs.generate_slug(3)}"
    channel5 = "#{MnemonicSlugs.generate_slug(3)}"
    channel6 = "#{MnemonicSlugs.generate_slug(3)}"

    ChatWeb.Endpoint.subscribe(topic)

    userid = UUID.uuid4()

    ChatWeb.Presence.track(self(), topic, userid, %{
      username: username,
      updated: "false",
      avatar: avatar
    })

    {:ok,
     assign(
       socket,
       topic: topic,
       room_id: room_id,
       id: userid,
       username: username,
       avatar: avatar,
       channel1: channel1,
       channel2: channel2,
       channel3: channel3,
       channel4: channel4,
       channel5: channel5,
       channel6: channel6,
       user_list: [],
       message: ""
     ), temporary_assigns: [messages: []]}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    if String.length(message) >= 3 && String.length(message) <= 100 do

      ChatWeb.Endpoint.broadcast(socket.assigns.topic, "new_message", %{
        uuid: UUID.uuid4(),
        content: message,
        username: socket.assigns.username,
        avatar: socket.assigns.avatar
      })
    end

    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_info(%{event: "new_message", payload: message}, socket) do
    Logger.info(message_received: message)
    {:noreply, assign(socket, messages: socket.assigns.messages ++ [message])}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
    {:noreply, assign(socket, message: message)}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages =
      joins
      |> Enum.map(fn {user_id, user_data} ->
        metas = Map.get(user_data, :metas, [])
        username = metas |> List.first() |> Map.get(:username, "unknown")
        %{uuid: UUID.uuid4(), content: "#{username} dołączył(a) do pokoju", username: "system"}
      end)

    leave_messages =
      leaves
      |> Enum.map(fn {user_id, user_data} ->
        metas = Map.get(user_data, :metas, [])
        username = metas |> List.first() |> Map.get(:username, "unknown")
        %{uuid: UUID.uuid4(), content: "#{username} opuscił(a) pokój", username: "system"}
      end)

    user_list =
      ChatWeb.Presence.list(socket.assigns.topic)
      |> Map.values()
      |> Enum.flat_map(fn user ->
        user[:metas] || []
      end)
      |> Enum.map(fn meta ->
        meta[:username]
      end)

    {:noreply,
     assign(
       socket,
       messages: socket.assigns.messages ++ join_messages ++ leave_messages,
       user_list: user_list,
     )}
  end
end
