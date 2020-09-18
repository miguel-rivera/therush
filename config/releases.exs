import Config

config :rush, RushWeb.Endpoint,
  server: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  live_view: [signing_salt: System.get_env("POSTGRES_SALT")]
# Configure your database
config :rush, Rush.Repo,
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  database: System.get_env("POSTGRES_DATABASE"),
  hostname: System.get_env("POSTGRES_HOST"),
  port: System.get_env("POSTGRES_PORT"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
