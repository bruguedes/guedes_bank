defmodule GuedesBank.Repo.Migrations.AddAccountTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :decimal, null: false
      add :account_number, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create constraint(:accounts, :balance_must_be_positive, check: "balance >= 0")
    create unique_index(:accounts, [:user_id], name: :unique_accounts_user)
    create index(:accounts, [:account_number])
  end
end
