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
    {:ok, socket}# socket is a liveView Socket that passes the endpoint for liveView todo web
  end

  @impl true
  def handle_event("create", %{"text" => text}, socket) do
    Item.create_item(%{text: text})
    socket = assign(socket, items: Item.list_items(), active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    {:noreply, socket}
  end


  @impl true
  def handle_info(%{event: "update", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end
end
