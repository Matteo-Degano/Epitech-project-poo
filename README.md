# T-POO-700

## Teams

- Matteo Degano
- Dulac Nathan
- Eva Ducéré
- Bryan Gast
- Thomas Loubat

## Setup

Pre-requisites:

- Docker
- Docker compose
- Make

### Backend

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

### Monitoring

Some metrics won't be availables if you are not on a Linux machine:

1. cAdvisor does not work on Windows and macOS machines
2. node_exporter partially work on Windows and macOS

```bash
cd ./monitoring
docker compose up --build
```

## Apps

### Monitoring

Services:

- Grafana
- Prometheus
- cAdvisor
- node_exporter (by Prometheus)
