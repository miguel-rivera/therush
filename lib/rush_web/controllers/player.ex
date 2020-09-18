defmodule RushWeb.Controller.Player do
  use RushWeb, :controller
  alias Rush.Rushers
  alias Rush.Repo

  def export(conn, %{"export"=> export_params}=_params) do

    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="rushers.csv"])
      |> send_chunked(:ok)

    {:ok, conn} =
      Repo.transaction(fn ->
        Rushers.stream_players_csv(export_params)
        |> Enum.reduce_while(conn, fn (data, conn) ->
        case chunk(conn, data) do
          {:ok, conn} ->
            {:cont, conn}
          {:error, :closed} ->
            {:halt, conn}
        end
      end)
    end)

    conn
  end
end
