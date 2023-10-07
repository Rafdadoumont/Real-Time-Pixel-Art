defmodule Project.CanvasTest do
  use Project.DataCase

  alias Project.Canvas

  describe "pixels" do
    alias Project.Canvas.Pixel

    import Project.CanvasFixtures

    @invalid_attrs %{color: nil, x: nil, y: nil}

    test "list_pixels/0 returns all pixels" do
      pixel = pixel_fixture()
      assert Canvas.list_pixels() == [pixel]
    end

    test "get_pixel!/1 returns the pixel with given id" do
      pixel = pixel_fixture()
      assert Canvas.get_pixel!(pixel.id) == pixel
    end

    test "create_pixel/1 with valid data creates a pixel" do
      valid_attrs = %{color: 42, x: 42, y: 42}

      assert {:ok, %Pixel{} = pixel} = Canvas.create_pixel(valid_attrs)
      assert pixel.color == 42
      assert pixel.x == 42
      assert pixel.y == 42
    end

    test "create_pixel/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvas.create_pixel(@invalid_attrs)
    end

    test "update_pixel/2 with valid data updates the pixel" do
      pixel = pixel_fixture()
      update_attrs = %{color: 43, x: 43, y: 43}

      assert {:ok, %Pixel{} = pixel} = Canvas.update_pixel(pixel, update_attrs)
      assert pixel.color == 43
      assert pixel.x == 43
      assert pixel.y == 43
    end

    test "update_pixel/2 with invalid data returns error changeset" do
      pixel = pixel_fixture()
      assert {:error, %Ecto.Changeset{}} = Canvas.update_pixel(pixel, @invalid_attrs)
      assert pixel == Canvas.get_pixel!(pixel.id)
    end

    test "delete_pixel/1 deletes the pixel" do
      pixel = pixel_fixture()
      assert {:ok, %Pixel{}} = Canvas.delete_pixel(pixel)
      assert_raise Ecto.NoResultsError, fn -> Canvas.get_pixel!(pixel.id) end
    end

    test "change_pixel/1 returns a pixel changeset" do
      pixel = pixel_fixture()
      assert %Ecto.Changeset{} = Canvas.change_pixel(pixel)
    end
  end
end
