defmodule Rush.Utils.Releases do
  @app :rush

  require Logger
  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end
  def update_rushing do
    start_app()
    priv_dir = priv_dir(:rush)

    rushing_json_path = "#{priv_dir}/repo/seeds/rushing.json"
    updated_rushers = Rush.Task.Rushing.import(rushing_json_path)
    Logger.info("#{updated_rushers} rushers added, using the: #{rushing_json_path} file.")
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end

  defp start_app do
    load_app()
    Application.put_env(@app, :minimal, true)
    Application.ensure_all_started(@app)
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"
end
