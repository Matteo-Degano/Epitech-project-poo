# Use an official Elixir image as a base
FROM elixir:1.17-alpine AS build

RUN mix archive.install hex phx_new
RUN mix phx.new . --no-html --app bootstrap --module Todolist --no-html

CMD ["./bin/your_app_name", "start"]

# Expose port for Phoenix (default is 4000)
EXPOSE 4000