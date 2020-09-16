defmodule Rush.Task.Rushing do
  @moduledoc """
    Support for importing Rushing.json file
  """
  import Rush.Rushers

  require Logger

  @spec import(String.t(), list) :: integer()
  def import(resource \\ "[]", opts \\ []) do
    cond do
      File.exists?(resource) -> File.read!(resource)
      URI.parse(resource) != :error -> fetch!(resource, opts)
      true -> resource
    end
    |> Jason.decode!()
    |> convert_players_list()
    |> Enum.reduce(0, &count_oks(create_player(&1), &2))
  end

  defp convert_players_list(players) do
    players
    |> Stream.map(&map_to_player_attributes/1)
  end

  defp map_to_player_attributes(
         %{
           "Player" => player,
           "Team" => team,
           "Pos" => position,
           "Att" => attempts,
           "Att/G" => attempts_per_game,
           "Yds" => yards,
           "Avg" => average,
           "Yds/G" => yards_per_game,
           "TD" => touchdowns,
           "Lng" => longest_rush,
           "1st" => first_down,
           "1st%" => first_down_percent,
           "20+" => twenty_plus_yards,
           "40+" => forty_plus_yards,
           "FUM" => fumbles
         } = _player
       ) do
    %{
      player: player,
      team: team,
      position: position,
      attempts: attempts,
      attempts_per_game: attempts_per_game,
      yards: yards,
      average: average,
      yards_per_game: yards_per_game,
      touchdowns: touchdowns,
      longest_rush: longest_rush,
      first_down: first_down,
      first_down_percent: first_down_percent,
      twenty_plus_yards: twenty_plus_yards,
      forty_plus_yards: forty_plus_yards,
      fumbles: fumbles
    }
  end

  defp count_oks({:ok, _}, count), do: count + 1

  defp count_oks({_, err}, count) do
    Logger.error(fn -> inspect(err) end)
    count
  end

  defp fetch!(_uri, _opts), do: raise("not supported")
end
