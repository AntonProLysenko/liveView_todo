defmodule LiveViewTodoWeb.PageLive do
  @moduledoc """
  This module is implementation of PageLive in router
  """
  alias Phoenix.PubSub
  use LiveViewTodoWeb, :live_view
  alias Phoenix.PubSub
  alias LiveViewTodo.Item
  alias LiveViewTodoWeb.ItemState

  @topic "live"



  @impl true
  def mount(_params, _session, socket) do
    # For each LiveView in the root of a template, mount/3 is invoked twice: once to do the initial page load and again to establish the live socket.
    #After declaring the mount function we need to let the app know that we are going to use it
    # our app know which html file to render by it's name the same name as this module with the extention .html.heex

    # subscribe to the channel
    if connected?(socket), do: LiveViewTodoWeb.Endpoint.subscribe(@topic); PubSub.subscribe(LiveViewTodo.PubSub, @topic)
    #adding Items to assigns

    {:ok, assign(socket, items: Item.list_items(), editing: nil, tab: "all")}# socket is a liveView Socket that passes the endpoint for liveView todo web
  end

  @impl true
  def handle_event("create", %{"text" => text}, socket) do
    Item.create_item(%{text: text})
    socket = assign(socket, items: get_all_sorted_items(), active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast_from(self(), @topic, "update", socket.assigns)
    PubSub.broadcast(LiveViewTodo.PubSub, @topic, socket.assigns)
    {:noreply, socket}
  end

  @impl true
  def handle_event("toggle", data, socket) do
    # IO.inspect(data, label: "data")
    # status = if Map.has_key?(data, "value"), do: 1, else: 0
    # item = Item.get_item!(Map.get(data, "id"))

    # Item.update_item(item, %{id: item.id, status: status})

    # socket = assign(socket, items: Item.list_items(), active: %Item{})
    # LiveViewTodoWeb.Endpoint.broadcast(@topic, "update", socket.assigns)
    # # {:noreply, socket}
    {:noreply, assign(socket, :items, ItemState.toggle(data))}
  end





  @impl true
  def handle_params(params, _url, socket) do
    items = Item.list_items()

    case params["filter_by"] do
      "completed" ->
        completed = Enum.filter(items, &(&1.status == 1))
        {:noreply, assign(socket, items: completed, tab: "completed")}

      "active" ->
        active = Enum.filter(items, &(&1.status == 0))
        {:noreply, assign(socket, items: active, tab: "active")}

      _ ->
        {:noreply, assign(socket, items: items, tab: "all")}
    end
  end


  def handle_info({:items, items}, socket) do
    {:noreply, assign(socket, items: items)}
  end

  # def handle_info({:active, item, :items, items}, socket) do
  #   {:noreply, assign(socket, items: items)}
  # end
  def handle_info(%{event: "update", payload: %{active: item, items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end
  @impl true
  def handle_info(%{event: "update", payload: %{items: items}}, socket) do
    {:noreply, assign(socket, items: items)}
  end





  defp get_all_sorted_items() do
    Enum.sort_by(Item.list_items(), &Map.fetch(&1, :inserted_at), :desc)
  end

end
