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

Run migrations

```bash
make migrate
```
