defmodule GuedesBank.Helpers.Query do
  @moduledoc "Query domain"

  import Ecto.Query

  alias GuedesBank.Repo

  def get(schema, id, type \\ "") do
    case Repo.get(schema, id) do
      nil -> {:error, String.to_atom(type <> "_not_found")}
      result -> {:ok, result}
    end
  end

  def get_by(schema, filters, type \\ "") do
    schema
    |> Repo.get_by(filters)
    |> case do
      nil -> {:error, String.to_atom(type <> "_not_found")}
      result -> {:ok, result}
    end
  end

  def exists?(schema, filters) do
    filters
    |> apply_filter(schema)
    |> Repo.exists?()
  end

  defp apply_filter(filters, schema) do
    filters
    |> Enum.reduce(schema, fn {key, value}, query ->
      if key in schema.__schema__(:fields) do
        where(query, [c], field(c, ^key) == ^value)
      else
        query
      end
    end)
  end
end
