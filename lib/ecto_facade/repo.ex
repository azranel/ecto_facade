defmodule EctoFacade.Repo do
  @moduledoc """
  Facade repository that should be used for all operations regarding ecto.

  It forwards all write/update/delete operations to `master_repo` and do all read operations on one of `read_repos` - which read repository is depending on the algorithm.

  Should be used as:
    use EctoFacade.Repo, master_repo: MyApp.Repo,
      read_repos: [MyApp.ReadRepoOne, MyApp.ReadRepoTwo],
      algorithm: MyApp.CustomReadRepoAlgorithm
      fallback_to_master: false

  Possible options:
    - `master_repo` - only option that is required, it should be main ecto repository used for writes (and reads if you use only one ecto repository)
    - `read_repos` - (optional) list of repositories that should be used for read operations. Defaults to [master_repo].
    - `algorithm` - (optional) Module that adhere to EctoFacade.Algorithm behaviour. Defaults to EctoFacade.Algorithms.Random
    - `fallback_to_master` - (optional) When no read repository is present, should query fallback to master repo (default: true)
  """

  @doc false
  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      master_repo = Keyword.get(opts, :master_repo)

      if master_repo == nil do
        raise ArgumentError,
              "Master repository should be provided to modules using EctoFacade.Repo"
      end

      algorithm = Keyword.get(opts, :algorithm, EctoFacade.Algorithms.Random)
      fallback_to_master = Keyword.get(opts, :fallback_to_master, true)

      @master_repo master_repo
      @read_repos Keyword.get(opts, :read_repos, [master_repo])
      @algorithm algorithm
      @fallback_to_master fallback_to_master

      unless is_list(@read_repos) do
        raise ArgumentError, "read_repos should be a list of repositories"
      end

      def master_repo, do: @master_repo

      def read_repos, do: @read_repos

      # Master repo write/update/delete operations
      defdelegate insert_all(schema_or_source, entries, opts \\ []), to: @master_repo
      defdelegate update_all(queryable, updates, opts \\ []), to: @master_repo
      defdelegate delete_all(queryable, opts \\ []), to: @master_repo
      defdelegate insert(struct, opts \\ []), to: @master_repo
      defdelegate update(struct, opts \\ []), to: @master_repo
      defdelegate insert_or_update(changeset, opts \\ []), to: @master_repo
      defdelegate delete(struct, opts \\ []), to: @master_repo
      defdelegate insert!(struct, opts \\ []), to: @master_repo
      defdelegate update!(struct, opts \\ []), to: @master_repo
      defdelegate insert_or_update!(changeset, opts \\ []), to: @master_repo
      defdelegate delete!(struct, opts \\ []), to: @master_repo

      if function_exported?(@master_repo.__adapter__, :transaction, 3) do
        defdelegate transaction(fun_or_multi, opts \\ []), to: @master_repo
        defdelegate in_transaction?(), to: @master_repo
        defdelegate rollback(value), to: @master_repo
      end

      # Read repos operations

      if @fallback_to_master do
        def all(queryable, opts \\ []) do
          try do
            get_read_repo().all(queryable, opts)
          catch
            _ -> @master_repo.all(queryable, opts)
          end
        end

        def stream(queryable, opts \\ []) do
          try do
            get_read_repo().stream(queryable, opts)
          catch
            _ -> @master_repo.stream(queryable, opts)
          end
        end

        def get(queryable, id, opts \\ []) do
          try do
            get_read_repo().get(queryable, id, opts)
          catch
            _ -> @master_repo.get(queryable, id, opts)
          end
        end

        def get!(queryable, id, opts \\ []) do
          try do
            get_read_repo().get!(queryable, id, opts)
          catch
            _ -> @master_repo.get!(queryable, id, opts)
          end
        end

        def get_by(queryable, clauses, opts \\ []) do
          try do
            get_read_repo().get_by(queryable, clauses, opts)
          catch
            _ -> @master_repo.get_by(queryable, clauses, opts)
          end
        end

        def get_by!(queryable, clauses, opts \\ []) do
          try do
            get_read_repo().get_by!(queryable, clauses, opts)
          catch
            _ -> @master_repo.get_by!(queryable, clauses, opts)
          end
        end

        def one(queryable, opts \\ []) do
          try do
            get_read_repo().one(queryable, opts)
          catch
            _ -> @master_repo.one(queryable, opts)
          end
        end

        def one!(queryable, opts \\ []) do
          try do
            get_read_repo().one!(queryable, opts)
          catch
            _ -> @master_repo.one!(queryable, opts)
          end
        end

        def aggregate(queryable, aggregate, field, opts \\ [])
            when aggregate in [:count, :avg, :max, :min, :sum] and is_atom(field) do
          try do
            get_read_repo().aggregate(queryable, aggregate, field, opts)
          catch
            _ -> @master_repo.aggregate(queryable, aggregate, field, opts)
          end
        end

        def preload(struct_or_structs_or_nil, preloads, opts \\ []) do
          try do
            get_read_repo().preload(struct_or_structs_or_nil, preloads, opts)
          catch
            _ -> @master_repo.preload(struct_or_structs_or_nil, preloads, opts)
          end
        end

        def load(schema_or_types, data) do
          try do
            get_read_repo().load(schema_or_types, data)
          catch
            _ -> @master_repo.load(schema_or_types, data)
          end
        end
      else
        def all(queryable, opts \\ []) do
          get_read_repo().all(queryable, opts)
        end

        def stream(queryable, opts \\ []), do: get_read_repo().stream(queryable, opts)

        def get(queryable, id, opts \\ []), do: get_read_repo().get(queryable, id, opts)

        def get!(queryable, id, opts \\ []), do: get_read_repo().get!(queryable, id, opts)

        def get_by(queryable, clauses, opts \\ []),
          do: get_read_repo().get_by(queryable, clauses, opts)

        def get_by!(queryable, clauses, opts \\ []),
          do: get_read_repo().get_by!(queryable, clauses, opts)

        def one(queryable, opts \\ []), do: get_read_repo().one(queryable, opts)

        def one!(queryable, opts \\ []), do: get_read_repo().one!(queryable, opts)

        def aggregate(queryable, aggregate, field, opts \\ [])
            when aggregate in [:count, :avg, :max, :min, :sum] and is_atom(field) do
          get_read_repo().aggregate(queryable, aggregate, field, opts)
        end

        def preload(struct_or_structs_or_nil, preloads, opts \\ []) do
          get_read_repo().preload(struct_or_structs_or_nil, preloads, opts)
        end

        def load(schema_or_types, data), do: get_read_repo().load(schema_or_types, data)
      end

      # Helper methods

      defp get_read_repo() when is_atom(@algorithm), do: @algorithm.get_repo(@read_repos)
    end
  end
end
