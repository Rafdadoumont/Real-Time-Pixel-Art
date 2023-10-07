defmodule Project.Canvas.Pixel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "pixels" do
    field :x, :integer, primary_key: true
    field :y, :integer, primary_key: true
    field :color, :integer
  end

  @doc false
  def changeset(pixel, attrs) do
    pixel
    |> cast(attrs, [:x, :y, :color])
    |> validate_required([:x, :y, :color])
  end
end
