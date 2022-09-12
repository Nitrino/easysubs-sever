defmodule Es.Repo do
  use Ecto.Repo,
    otp_app: :es,
    adapter: Ecto.Adapters.Postgres
end
