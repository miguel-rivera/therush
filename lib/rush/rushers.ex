defmodule Rush.Rushers do
  @moduledoc """
  The Rushers context.
  """

  import Ecto.Query, warn: false
  alias Rush.Repo

  alias Rush.Rushers.Player

   @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

  """

  def list_players(params \\ %{}) do
    from(
      p in Player,
      order_by: ^filter_order_by(params["order_by"])
    )
    |> search_players(params["query"])
    |> Repo.all()
  end

  defp filter_order_by("yards"), do: [desc: :yards]
  defp filter_order_by("longest_rush"), do: [desc: :longest_rush]
  defp filter_order_by("touchdowns"), do: [desc: :touchdowns]
  defp filter_order_by(_), do: []

  defp search_players(queryable, search_phrase) when not is_nil(search_phrase) do
    like_term = "%#{String.downcase(search_phrase)}%"

    queryable
    |> where([p], like(fragment("lower(?)", p.name), ^like_term))
  end

  defp search_players(queryable, _), do: queryable


  @doc """
  Returns a stream of comma deliminated players.
  """
  def stream_players_csv( params \\ %{}) do
    columns = ["name", "team", "position", "attempts", "attempts_per_game", "average", "first_downs", "first_down_percent", "forty_plus_yards", "fumbles", "longest_rush", "touchdowns", "twenty_plus_yards", "yards", "yards_per_game"]
    where_clause = if params["query"] == "", do: "", else: "WHERE (lower(p.name) LIKE \'%#{String.downcase(params["query"])}%\') "
    order_clause = if params["order_by"] == "", do: "", else: "ORDER BY p.#{params["order_by"]} DESC "
    select_query = "SELECT #{Enum.join(columns, ",")} FROM players p " <> where_clause <> order_clause

    stream_query = """
    COPY (
      #{select_query}
      ) to
      STDOUT WITH CSV DELIMITER ',' ESCAPE '\"'
    """
    csv_header = [Enum.join(columns, ","), "\n"]
    Ecto.Adapters.SQL.stream(Repo, stream_query)
      |> Stream.map(&(&1.rows))
      |> (fn stream -> Stream.concat(csv_header, stream) end).()
  end



  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end
end
