defmodule LiveViewTodoWeb.PageLive do
  @moduledoc """
  This module is implementation of PageLive in router
  """
  use LiveViewTodoWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    # For each LiveView in the root of a template, mount/3 is invoked twice: once to do the initial page load and again to establish the live socket.
    #After declaring the mount function we need to let the app know that we are going to use it
    # our app know which html file to render by it's name the same name as this module with the extention .html.heex
    {:ok, socket}# socket is a liveView Socket that passes the endpoint for liveView todo web
  end
end
