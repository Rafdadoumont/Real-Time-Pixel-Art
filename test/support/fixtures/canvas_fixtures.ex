defmodule Project.CanvasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Project.Canvas` context.
  """

  @doc """
  Generate a pixel.
  """
  def pixel_fixture(attrs \\ %{}) do
    {:ok, pixel} =
      attrs
      |> Enum.into(%{
        color: 42,
        x: 42,
        y: 42
      })
      |> Project.Canvas.create_pixel()

    pixel
  end
end
