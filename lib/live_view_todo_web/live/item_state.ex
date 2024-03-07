defmodule LiveViewTodoWeb.ItemState do
  use GenServer
  alias Phoenix.PubSub
  alias LiveViewTodo.Item

  @name :item_server

  def topic do
    "live"
  end

  def start_link(_opts)do
    GenServer.start_link(__MODULE__, Item.list_items(), name: @name)
  end

  def toggle(data) do
    GenServer.call(@name, {:toggle, data})
  end

  def create(text)do
    GenServer.call(@name, {:create, text})
  end

  #IMPL

  @impl true
  def init(items) do
    {:ok, items}
  end


  @impl true

  def handle_call({:toggle, data}, _from, items) do
    status = if Map.has_key?(data, "value"), do: 1, else: 0

    updated_items = update_and_fetch(data["id"], status, items)

    PubSub.broadcast(LiveViewTodo.PubSub, topic(), {:items, updated_items})
    {:reply, items, updated_items}
  end

  @impl true
  def handle_call({:create, text},_from, _socket) do

    Item.create_item(%{text: text})
    socket = Item.list_items()
    PubSub.broadcast(LiveViewTodo.PubSub, topic(), {:items, socket})
    # PubSub.broadcast(LiveViewTodo.PubSub, @topic, socket.assigns)
    {:reply, socket, socket}

  end

  defp update_and_fetch(id, new_status, items) do
    item = Enum.find(items, fn item ->
      to_string(item.id) == id
    end)
    Item.update_item(item, %{id: id, status: new_status})
    Item.list_items()
        # IO.inspect(item, label: "Found")
        # Map.replace(item, :status, status)
        # |> IO.inspect(label: "replaced")
  end

end
