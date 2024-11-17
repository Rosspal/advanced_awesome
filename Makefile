SHELL := /bin/bash
.SHELLFLAGS := -c -e

.PHONY: up test iex down

COMPOSE_ENV := docker compose --env-file .local.env

up:
	$(COMPOSE_ENV) up --wait

test:
	set -o allexport; source .local.env; set +o allexport; \
	mix deps.get; \
	mix test

iex:
	set -o allexport; source .local.env; set +o allexport; \
	mix deps.get; \
	mix ecto.setup; \
	iex -S mix

iex-server:
	set -o allexport; source .local.env; set +o allexport; \
	mix deps.get; \
	mix ecto.setup; \
	iex -S mix phx.server

down:
	$(COMPOSE_ENV) down
