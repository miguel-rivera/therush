defmodule RushWeb.PlayerLive.Index do
  use RushWeb, :live_view

  alias Rush.Rushers

  @impl true
  def mount(_params, _session, socket) do

    %{entries: entries, page_number: page_number, total_pages: total_pages} =
    if connected?(socket)  do
      Rushers.paginate_players()
    else
      %Scrivener.Page{}
    end

    assigns =
      socket
      |> assign(:players, entries)
      |> assign(:page_number, page_number || 0)
      |> assign(:total_pages, total_pages || 0)
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

    %{
      entries: entries,
      page_number: page_number,
      total_pages: total_pages
    } = Rushers.paginate_players(params)

    {:noreply, assign(socket, players: entries, query: params["query"], order_by: params["order_by"], total_pages: total_pages, page_number: page_number)}
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


end
