# T-POO-700

## Teams

- Matteo Degano
- Dulac Nathan
- Eva Ducéré
- Bryan Gast
- Thomas Loubat

## Setup

### Backend

Pre-requisites:

- Docker
- Docker compose
- Make

1. Copy `.env` template and edit env variables

```bash
cp ./backend/.env.example ./backend/.env
```

Run compose

```bash
docker compose up --build --force-recreate
```

Add auth secret

```bash
docker exec -it backend mix guardian.gen.secret
```

copy/paste secret in backend .env file

Run migrations

```bash
make migrate
```

If ecto say that the column (or index) does not exist, comment the line in the migration, run `docker exec -it backend mix ecto.rollback --all` then uncomment it and rerun the migration.
