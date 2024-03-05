defmodule LiveViewTodoWeb.ToolbarComponent do
  use LiveViewTodoWeb, :live_component
  alias LiveViewTodo.Item

  @topic "live"

  attr(:tab, :string, default: "all")
  attr(:items, :list, default: [])

  def render(assigns) do
    ~H"""
      <footer class="footer" style="display: block;">
        <span class="todo-count">
          <strong>
            <%= Enum.count(Enum.filter(@items, fn i -> i.status == 0 end)) %>
          </strong>
          <%= if Enum.count(Enum.filter(@items, fn i -> i.status ==0 end)) == 1 do %>
            item
          <% else %>
            items
          <% end %>
          left
        </span>
        <ul class="filters">
        <li>
          <.link
            class={if @tab == "all", do: "selected", else: ""}
            patch={Routes.live_path(@socket, LiveViewTodoWeb.PageLive, %{filter_by: "all"})}
          >
            All
          </.link>
        </li>
        <li>
          <.link
            class={if @tab == "active", do: "selected", else: ""}
            patch={Routes.live_path(@socket, LiveViewTodoWeb.PageLive, %{filter_by: "active"})}
          >
            Active
          </.link>
        </li>
        <li>
          <.link
            class={if @tab == "completed", do: "selected", else: ""}
            patch={Routes.live_path(@socket, LiveViewTodoWeb.PageLive, %{filter_by: "completed"})}
          >
            Completed
          </.link>
        </li>
      </ul>
        <button class="clear-completed" style="display: block;" phx-target={@myself} phx-click="clear-completed">
          Clear completed
        </button>
      </footer>
    """
  end



  @impl true
  def handle_event("clear-completed", _data, socket) do
    Item.clear_completed()
    items = Item.list_items()
    socket = assign(socket, items: items, active: %Item{})
    LiveViewTodoWeb.Endpoint.broadcast(@topic, "update", socket.assigns)
    {:noreply, socket}
  end

end
