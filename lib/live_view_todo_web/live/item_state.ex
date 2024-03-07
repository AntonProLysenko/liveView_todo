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

  #IMPL

  @impl true
  def init(items) do
    {:ok, items}
  end


  @impl true

  def handle_call({:toggle, data}, _from, items) do
    status = if Map.has_key?(data, "value"), do: 1, else: 0

    updated_items =
      Enum.map(items, fn item ->
        if to_string(item.id) == data["id"] do
          Item.update_item(item, %{id: item.id, status: status})
          IO.inspect(item, label: "Found")
          Map.replace(item, :status, status)
          |> IO.inspect(label: "replaced")
        else
          item
        end
      end)
      # IO.inspect("MAYBE HERE??????")
    PubSub.broadcast(LiveViewTodo.PubSub, topic(), {:items, updated_items})
    {:reply, updated_items, updated_items}
  end

end
