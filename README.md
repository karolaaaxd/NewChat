# Chat

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Recreation steps

1. Add mnemonic_slugs library
2. Add button in PageLive to create new room
3. Add handle_event to PageLive to respond to the "new-room" event by redirecting user to new room
4. Add RoomLive live with template which displays the name of the room
5. Add chat window with text form
6. Add form submission (submit_message), broadcast new message and display it
7. Make text input clear when submitting message
8. Add usernames and display them

