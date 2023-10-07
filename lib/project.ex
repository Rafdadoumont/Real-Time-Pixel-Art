defmodule Project do
  @moduledoc """
  Project keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmodule State do
    defmodule Canvas do

      def canvas_size, do: 100

      def init(pixels) do
        Agent.start_link(fn -> for _ <- 0..canvas_size()*canvas_size(), into: Arrays.new(), do: <<63>> end, name: __MODULE__)
        for pixel <- pixels, do: update_state_pixel(pixel.x, pixel.y, pixel.color)
      end

      def get_pixels() do
        Agent.get(__MODULE__, fn canvas -> for pixel <- canvas, do: pixel, into: "" end)
      end

      defp update_state_pixel(x, y, color) do
        Agent.update(__MODULE__, fn canvas -> put_in(canvas[x+(y*canvas_size())], <<color>>) end)
      end

      def update_pixel(x, y, color) do
        pixel = Project.Canvas.get_pixel(x, y)

        if pixel == nil do
          Project.Canvas.create_pixel(%{x: x, y: y, color: color})
        else
          Project.Canvas.update_pixel(pixel, %{x: x, y: y, color: color})
        end

        update_state_pixel(x, y, color)
        Phoenix.PubSub.broadcast(:canvas_pubsub, "update-pixel", %{x: x, y: y, color: color})
      end
    end
  end
end
