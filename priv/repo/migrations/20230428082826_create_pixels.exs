defmodule Project.Repo.Migrations.CreatePixels do
  use Ecto.Migration

  def change do
    create table(:pixels, primary_key: false) do
      add :x, :integer, primary_key: true
      add :y, :integer, primary_key: true
      add :color, :integer, null: false
    end
  end
end
