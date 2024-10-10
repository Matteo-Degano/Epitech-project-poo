FROM elixir

WORKDIR /app
COPY . .
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt install -y \
  build-essential \
  inotify-tools \
  postgresql-client

RUN mix local.hex --force && \
  mix local.rebar --force

RUN mix deps.get \
  mix deps.compile

CMD mix phx.server

EXPOSE 4000