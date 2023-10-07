defmodule Project.Canvas do
  @moduledoc """
  The Canvas context.
  """

  import Ecto.Query, warn: false
  alias Project.Repo

  alias Project.Canvas.Pixel

  @doc """
  Returns the list of pixels.

  ## Examples

      iex> list_pixels()
      [%Pixel{}, ...]

  """
  def list_pixels do
    Repo.all(Pixel)
  end

  @doc """
  Gets a single pixel.

  ## Examples

      iex> get_pixel(123)
      %Pixel{}

  """
  def get_pixel(x, y), do: Repo.get_by(Pixel, [x: x, y: y])

  @doc """
  Creates a pixel.

  ## Examples

      iex> create_pixel(%{field: value})
      {:ok, %Pixel{}}

      iex> create_pixel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pixel(attrs \\ %{}) do
    %Pixel{}
    |> Pixel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pixel.

  ## Examples

      iex> update_pixel(pixel, %{field: new_value})
      {:ok, %Pixel{}}

      iex> update_pixel(pixel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pixel(%Pixel{} = pixel, attrs) do
    pixel
    |> Pixel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pixel.

  ## Examples

      iex> delete_pixel(pixel)
      {:ok, %Pixel{}}

      iex> delete_pixel(pixel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pixel(%Pixel{} = pixel) do
    Repo.delete(pixel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pixel changes.

  ## Examples

      iex> change_pixel(pixel)
      %Ecto.Changeset{data: %Pixel{}}

  """
  def change_pixel(%Pixel{} = pixel, attrs \\ %{}) do
    Pixel.changeset(pixel, attrs)
  end
end
