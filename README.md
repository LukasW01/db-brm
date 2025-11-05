# DB

A SQL backup and restore manager that safely stores your database dumps in a local or remote location and provides notifications via Discord webhooks, Pushover, or SMTP.

## Getting Started

### Prerequisites

- [Elixir](https://elixir-lang.org/install.html)
- [Node.js](https://nodejs.org/en/download/)
- [PostgreSQL](https://www.postgresql.org/download/)
- [Phoenix](https://hexdocs.pm/phoenix/installation.html)
- [Docker](https://docs.docker.com/get-docker/)

### Installation

Install dependencies

```bash
cd assets && npm install
```

Run setup

```bash
mix setup
```

Start the server

```bash
mix phx.server
```

## License

This program is licensed under the Business Source License 1.1. See the "LICENSE" file for more information
