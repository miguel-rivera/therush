defmodule RushWeb.PlayerLive.Index do
  use RushWeb, :live_view

  alias Rush.Rushers

  @impl true
  def mount(_params, _session, socket) do
    assigns =
      socket
      |> assign(:players, list_players())
      |> assign(:player_name, nil)
      |> assign(:order_by, nil)

    {:ok, assigns}
  end

  @impl true

  def handle_params(_params, :index, socket) do
    socket_assigns =
      socket
      |> assign(:page_title, "Listing Players")
      |> assign(:player, nil)
      |> assign(:player_name, nil)
      |> assign(:order_by, nil)

    {:noreply, socket_assigns}
  end

  def handle_params(params, _url, socket) do
    {:noreply, assign(socket, players: Rushers.list_players(params), query: params["query"], order_by: params["order_by"])}
  end

  @impl true
  def handle_event("query", %{"query" => search_term}, socket) do
    {:noreply, patch_with_query_attrs(socket, %{query: search_term})}
  end

  defp patch_with_query_attrs(socket, attrs) do
    query = attrs[:query] || socket.assigns[:query]
    order_by = attrs[:order_by] || socket.assigns[:order_by]
    push_patch(socket, to: Routes.player_index_path(socket, :index, %{query: query, order_by: order_by}))
  end

  defp list_players do
    Rushers.list_players()
  end
end
