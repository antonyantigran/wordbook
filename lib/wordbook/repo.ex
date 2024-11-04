defmodule Wordbook.Repo do
  use Ecto.Repo,
    otp_app: :wordbook,
    adapter: Ecto.Adapters.Postgres
end
