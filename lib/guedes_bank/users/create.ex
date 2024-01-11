defmodule GuedesBank.Users.Create do
  @moduledoc "Create User domain"

  alias GuedesBank.ExternalClient.ViaCep
  alias GuedesBank.Repo
  alias GuedesBank.Users.Inputs.CreateUser
  alias GuedesBank.Users.Schema.User

  @spec call(CreateUser.t()) :: {:ok, User.t()} | {:errsor, atom() | Ecto.Changeset.t()}
  def call(%CreateUser{cep: cep} = params) do
    cep
    |> client().call()
    |> case do
      {:ok, _} ->
        do_call(params)

      _ ->
        {:error, :invalid_cep}
    end
  end

  defp do_call(params) do
    params
    |> Map.from_struct()
    |> User.changeset()
    |> Repo.insert()
  end

  defp client do
    Application.get_env(:guedes_bank, :via_cep, ViaCep)
  end
end
