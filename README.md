# Datastore

Proof of concept of Form builder Datastore in Elixir.

## Setup

Requirements:

* Docker

```
 docker-compose up -d
 docker-compose exec mix ecto.migrate
```

## Requests

The application on docker runs in the 9000 port. So examples below will use
that as example.

To create or update data:
```
curl -X POST http://0.0.0.0:9000/api/service/cica/user/cb59d86e-506a-4aab-a19f-7a66702bc6e0 -d '{"user_data": { "payload": "encrypted_payload"}}' -H "accept: application/json" -H "content-type: application/json"
```

To find the data:

```
curl -X GET http://0.0.0.0:9000/api/service/cica/user/cb59d86e-506a-4aab-a19f-7a66702bc6e0 -H "accept: application/json" -H content-type: application/json"
```
