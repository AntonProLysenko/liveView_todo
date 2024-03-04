defmodule LiveViewTodoWeb.PageLive do
  @moduledoc """
  This module is implementation of PageLive in router
  """
  use LiveViewTodoWeb, :live_view

  alias LiveViewTodo.Item


  @impl true
  @topic "live"



  def mount(_params, _session, socket) do
    # For each LiveView in the root of a template, mount/3 is invoked twice: once to do the initial page load and again to establish the live socket.
    #After declaring the mount function we need to let the app know that we are going to use it
    # our app know which html file to render by it's name the same name as this module with the extention .html.heex

    # subscribe to the channel
    if connected?(socket), do: LiveViewTodoWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, items: Item.list_items(), editing: nil, tab: "all")}# socket is a liveView Socket that passes the endpoint for liveView todo web
  end

  @impl true
  def handle_event("create", %{"text" => text}, socket) do
    Item.create_item(%{text: text})
    IO.puts("CREATING")
    socket = assign(socket, items: Item.list_items(), active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    IO.inspect(socket.items, label: "ITEMS in SOCKET")
    {:noreply, socket}
  end


  @impl true
  def handle_info(%{event: "update", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end



  def checked?(item) do
    not is_nil(item.status) and item.status > 0
  end

  def completed?(item) do
    if not is_nil(item.status) and item.status > 0, do: "completed", else: ""
  end
end
