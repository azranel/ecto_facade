defmodule EctoFacade.Algorithm do
  @callback get_repo([Ecto.Repo.t]) :: Ecto.Repo.t
end