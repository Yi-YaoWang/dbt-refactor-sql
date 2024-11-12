#!/bin/bash
podman pod create --name postgre-sql -p 9876:80 -p 5432:5432
podman run -d --pod postgre-sql --name db -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=Passw0rd -v pgdata:/var/lib/postgresql/data -d docker.io/postgres:latest