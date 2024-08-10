# GuedesBank

## Project Description

GuedesBank is a banking application developed with the Phoenix framework. The goal of the project is to provide basic banking functionalities such as deposits, withdrawals, and account transfers.

## Next Steps

### NEXT TODO
- Add unit tests for the modules:
  - `transactions.ex`
  - `querys.ex`
  - `delete.ex`
  - `update.ex`
  - `auth.ex`
- Refactor to support account deposits and withdrawals via transfer
- Implement deposit and withdrawal transactions
- Retrieve account balance
- Create a schema to store transactions [id, from_account, to_account, value, created_at]
- Return the transaction id and the inserted_at timestamp
- Publish a notification to the users involved in the transaction

## Starting the Phoenix Server

To start the Phoenix server:
1. Start the database using Docker: `docker-compose up -d`
2. Run `mix setup` to install and set up dependencies.
3. Start the Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) in your browser.

## Production Deployment

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn More

- **Official Website:** [Phoenix Framework](https://www.phoenixframework.org/)
- **Guides:** [Phoenix Overview](https://hexdocs.pm/phoenix/overview.html)
- **Documentation:** [Phoenix Docs](https://hexdocs.pm/phoenix)
- **Forum:** [Elixir Forum - Phoenix](https://elixirforum.com/c/phoenix-forum)
- **Source Code:** [Phoenix GitHub Repository](https://github.com/phoenixframework/phoenix)
