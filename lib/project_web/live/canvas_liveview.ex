defmodule ProjectWeb.CanvasLive do
  use Phoenix.LiveView

  alias Project.State.Canvas

  def render(assigns) do
    canvas_size = Canvas.canvas_size()
    ~L"""
    <div id="div" class="center">
      <canvas id="canvas" class="pixelated margin-auto" phx-hook="canvas" width="<%= canvas_size %>" height="<%= canvas_size %>">
        Canvas is not supported
      </canvas>
      <canvas id="color-picker" class="pixelated margin-auto"></canvas>
    </div>
    <img id="pixel-select" class="absolute" src="/images/pixelselect.png" style="display: none;"/>
    """
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(:canvas_pubsub, "update-pixel")
    {:ok, socket}
  end

  def handle_info(pixel, socket) do
    {:noreply, push_event(socket, "update-pixel", pixel)}
  end

  def handle_event("request-pixels", _params, socket) do
    {:noreply, push_event(socket, "initialize-pixels", %{pixels: Canvas.get_pixels(), canvasSize: Canvas.canvas_size()})}
  end

  def handle_event("request-update-pixel", params, socket) do
    Canvas.update_pixel(params["x"], params["y"], params["color"])
    {:noreply, socket}
  end
end
