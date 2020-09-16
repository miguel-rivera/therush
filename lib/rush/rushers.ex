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
    |> Repo.all()
  end

  defp filter_order_by("yards"), do: [desc: :yards]
  defp filter_order_by("longest_rush"), do: [desc: :longest_rush]
  defp filter_order_by("touchdowns"), do: [desc: :touchdowns]
  defp filter_order_by(_), do: []
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


  @doc """
  Fuzzy Search for players
  """
  def search_players(search_phrase) do
    like_term = "%#{String.downcase(search_phrase)}%"

    from(
      p in Player,
      where: like(fragment("lower(?)", p.player), ^like_term)
    )
    |> Repo.all()
  end
end
