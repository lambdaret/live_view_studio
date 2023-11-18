defmodule LiveViewStudio.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :color, :string
      add :make, :string
      add :model, :string

      timestamps(type: :timestamptz)
    end
  end
end
