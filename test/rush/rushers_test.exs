defmodule Rush.RushersTest do
  use Rush.DataCase

  alias Rush.Rushers

  describe "players" do
    alias Rush.Rushers.Player

    @valid_attrs %{attempts: 42, attempts_per_game: 120.5, average: 120.5, first_down_percent: 120.5, first_downs: 42, forty_plus_yards: 42, fumbles: 42, longest_rush: "some longest_rush", player: "some player", position: "some position", team: "some team", touchdowns: 42, twenty_plus_yards: 42, yards: 42, yards_per_game: 120.5}
    @update_attrs %{attempts: 43, attempts_per_game: 456.7, average: 456.7, first_down_percent: 456.7, first_downs: 43, forty_plus_yards: 43, fumbles: 43, longest_rush: "some updated longest_rush", player: "some updated player", position: "some updated position", team: "some updated team", touchdowns: 43, twenty_plus_yards: 43, yards: 43, yards_per_game: 456.7}
    @invalid_attrs %{attempts: nil, attempts_per_game: nil, average: nil, first_down_percent: nil, first_downs: nil, forty_plus_yards: nil, fumbles: nil, longest_rush: nil, player: nil, position: nil, team: nil, touchdowns: nil, twenty_plus_yards: nil, yards: nil, yards_per_game: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rushers.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Rushers.list_players() == [player]
    end

    test "list_players/0 returns sorted players by yards" do
      player_sorted_yards = player_fixture()
      |> Enum.sort_by( fn player -> player.yards end, :desc)

      assert Rushers.list_players(%{"order_by" => "yards"}) == [player]
    end

    test "list_players/0 returns sorted players by longest_rush" do
      player_sorted_yards = player_fixture()
      |> Enum.sort_by( fn player -> player.yards end, :desc)

      assert Rushers.list_players(%{"order_by" => "longest_rush"}) == [player]
    end

    test "list_players/0 returns sorted players by touchdowns" do
      player_sorted_yards = player_fixture()
      |> Enum.sort_by( fn player -> player.yards end, :desc)

      assert Rushers.list_players(%{"order_by" => "touchdowns"}) == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Rushers.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Rushers.create_player(@valid_attrs)
      assert player.attempts == 42
      assert player.attempts_per_game == 120.5
      assert player.average == 120.5
      assert player.first_down_percent == 120.5
      assert player.first_downs == 42
      assert player.forty_plus_yards == 42
      assert player.fumbles == 42
      assert player.longest_rush == "some longest_rush"
      assert player.player == "some player"
      assert player.position == "some position"
      assert player.team == "some team"
      assert player.touchdowns == 42
      assert player.twenty_plus_yards == 42
      assert player.yards == 42
      assert player.yards_per_game == 120.5
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rushers.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Rushers.update_player(player, @update_attrs)
      assert player.attempts == 43
      assert player.attempts_per_game == 456.7
      assert player.average == 456.7
      assert player.first_down_percent == 456.7
      assert player.first_downs == 43
      assert player.forty_plus_yards == 43
      assert player.fumbles == 43
      assert player.longest_rush == "some updated longest_rush"
      assert player.player == "some updated player"
      assert player.position == "some updated position"
      assert player.team == "some updated team"
      assert player.touchdowns == 43
      assert player.twenty_plus_yards == 43
      assert player.yards == 43
      assert player.yards_per_game == 456.7
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Rushers.update_player(player, @invalid_attrs)
      assert player == Rushers.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Rushers.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Rushers.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Rushers.change_player(player)
    end
  end
end
