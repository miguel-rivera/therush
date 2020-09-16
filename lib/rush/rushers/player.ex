defmodule Rush.Rushers.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :attempts, :integer
    field :attempts_per_game, :float
    field :average, :float
    field :first_down_percent, :float
    field :first_downs, :integer
    field :forty_plus_yards, :integer
    field :fumbles, :integer
    field :longest_rush, :string
    field :player, :string
    field :position, :string
    field :team, :string
    field :touchdowns, :integer
    field :twenty_plus_yards, :integer
    field :yards, :integer
    field :yards_per_game, :float

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:player, :team, :position, :attempts, :attempts_per_game, :average, :first_downs, :first_down_percent, :forty_plus_yards, :fumbles, :longest_rush, :touchdowns, :twenty_plus_yards, :yards, :yards_per_game])
    |> validate_required([:player])
  end
end
