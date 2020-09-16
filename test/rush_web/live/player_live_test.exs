defmodule RushWeb.PlayerLiveTest do
  use RushWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Rush.Rushers

  @create_attrs %{attempts: 42, attempts_per_game: 120.5, average: 120.5, first_down_percent: 120.5, first_downs: 42, forty_plus_yards: 42, fumbles: 42, longest_rush: "some longest_rush", player: "some player", position: "some position", team: "some team", touchdowns: 42, twenty_plus_yards: 42, yards: 42, yards_per_game: 120.5}
  @update_attrs %{attempts: 43, attempts_per_game: 456.7, average: 456.7, first_down_percent: 456.7, first_downs: 43, forty_plus_yards: 43, fumbles: 43, longest_rush: "some updated longest_rush", player: "some updated player", position: "some updated position", team: "some updated team", touchdowns: 43, twenty_plus_yards: 43, yards: 43, yards_per_game: 456.7}
  @invalid_attrs %{attempts: nil, attempts_per_game: nil, average: nil, first_down_percent: nil, first_downs: nil, forty_plus_yards: nil, fumbles: nil, longest_rush: nil, player: nil, position: nil, team: nil, touchdowns: nil, twenty_plus_yards: nil, yards: nil, yards_per_game: nil}

  defp fixture(:player) do
    {:ok, player} = Rushers.create_player(@create_attrs)
    player
  end

  defp create_player(_) do
    player = fixture(:player)
    %{player: player}
  end

  describe "Index" do
    setup [:create_player]

    test "lists all players", %{conn: conn, player: player} do
      {:ok, _index_live, html} = live(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Listing Players"
      assert html =~ player.longest_rush
    end

    test "saves new player", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("a", "New Player") |> render_click() =~
               "New Player"

      assert_patch(index_live, Routes.player_index_path(conn, :new))

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Player created successfully"
      assert html =~ "some longest_rush"
    end

    test "updates player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("#player-#{player.id} a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(index_live, Routes.player_index_path(conn, :edit, player))

      assert index_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_index_path(conn, :index))

      assert html =~ "Player updated successfully"
      assert html =~ "some updated longest_rush"
    end

    test "deletes player in listing", %{conn: conn, player: player} do
      {:ok, index_live, _html} = live(conn, Routes.player_index_path(conn, :index))

      assert index_live |> element("#player-#{player.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#player-#{player.id}")
    end
  end

  describe "Show" do
    setup [:create_player]

    test "displays player", %{conn: conn, player: player} do
      {:ok, _show_live, html} = live(conn, Routes.player_show_path(conn, :show, player))

      assert html =~ "Show Player"
      assert html =~ player.longest_rush
    end

    test "updates player within modal", %{conn: conn, player: player} do
      {:ok, show_live, _html} = live(conn, Routes.player_show_path(conn, :show, player))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Player"

      assert_patch(show_live, Routes.player_show_path(conn, :edit, player))

      assert show_live
             |> form("#player-form", player: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#player-form", player: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.player_show_path(conn, :show, player))

      assert html =~ "Player updated successfully"
      assert html =~ "some updated longest_rush"
    end
  end
end
