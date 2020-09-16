defmodule Rush.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :player, :string
      add :team, :string
      add :position, :string
      add :attempts, :integer
      add :attempts_per_game, :float
      add :average, :float
      add :first_downs, :integer
      add :first_down_percent, :float
      add :forty_plus_yards, :integer
      add :fumbles, :integer
      add :longest_rush, :string
      add :touchdowns, :integer
      add :twenty_plus_yards, :integer
      add :yards, :integer
      add :yards_per_game, :float

      timestamps()
    end

    create index("players", [:yards])
    create index("players", [:longest_rush])
    create index("players", [:touchdowns])
  end
end
