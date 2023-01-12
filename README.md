# OPA PoC
This is to demonstrate the working on OPA to overcome the use-case of static routes access binding for HP Admin Console use-case. 
Refer to the codes here: https://github.com/Samarth-HP/esamwad-backend/pull/40/files#diff-9a1065083d3570eaacd486cd58f3b347b49dcb42678ecd88d880bab3c62c04abR82

We'll run a standalone OPA server which will validate the incoming request META data (request URL, method & authorization token) against the user's access & returns true/false based on the business logic defined in rego file.

# Setup
- Copy `sample.env` to `.env` and configure variables
- Generate bundle with command `./opa build -b ./hp_admin_console` & move the generated file `bundle.tar.gz` to `bundles/` directory
- Hit `docker-compose up -d`

OPA server will be accessible at port 8181.

# Test:
- Try if the access is allowed to admin with a valid token:

```
curl --location --request POST 'http://localhost:8181/v1/data/esamwad/backend/admin_console/allow' \
--header 'Content-Type: application/json' \
--data-raw '{
    "input": {
        "request": {
            "method": "GET",
            "path": "/api/v5/assessment/invalidate",
            "headers": {
                "authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlVVdzVZdVFWNnd2R29PdmZYNHBxWTdwS18zbyJ9.eyJhdWQiOiI3NzYzODg0Ny1kYjM0LTQzMzEtYjM2OS01NzY4ZmRmZWRlZGQiLCJleHAiOjI1MzU4MTgzNDMsImlhdCI6MTY3MTgxODM0MywiaXNzIjoiYWNtZS5jb20iLCJzdWIiOiIxNTgyOWVhNC1kNTdhLTRjNTItODU5ZS0wNTkwMDFjNjFiZmIiLCJqdGkiOiJiNDNmMzYzYS1kNWZiLTQ2MDEtYTViZi1mNjdjOTQ0MDE4OWYiLCJhdXRoZW50aWNhdGlvblR5cGUiOiJQQVNTV09SRCIsImVtYWlsIjoic2FtYXJ0aC1hZG1pbkBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwicHJlZmVycmVkX3VzZXJuYW1lIjoic2FtYXJ0aC1hZG1pbiIsImFwcGxpY2F0aW9uSWQiOiI3NzYzODg0Ny1kYjM0LTQzMzEtYjM2OS01NzY4ZmRmZWRlZGQiLCJyb2xlcyI6WyJBZG1pbiJdLCJodHRwczovL2hhc3VyYS5pby9qd3QvY2xhaW1zIjp7IngtaGFzdXJhLWFsbG93ZWQtcm9sZXMiOlsiU3RhdGUgQWRtaW4iLCJEaXN0cmljdCBBZG1pbiIsIkJsb2NrIEFkbWluIiwiU2Nob29sIEFkbWluIiwiQWRtaW4iXSwieC1oYXN1cmEtZGVmYXVsdC1yb2xlIjoiQWRtaW4ifX0.dmUz-1BQenGQGbgy3aoKsTkBU2LjWf9YafZxYqMUOgtzhL29pvauUu-Cv-d9q4ohkcu6bKsg1I2aGAhj3eJ_0cAAHwflIylnExrl15EQQyoVV_yzXOmHT0gITjByD-GkrnKIpUNz_60We7Ae2cRGXD27UpEap7tls-l8WR8i35vNB5e79ZOKUxk6ZSX_0HzPjbRGSDc79Cx75mGsPpaQeYahEBLymyxHni3Rg6oK-AGM8L4lV-sstqC1TPrPNWfnaro2E9GJKXGV_whCwHGfxwyzdqy0Q5fNkATJ10lQSBzFtz6Dv2xaoX47GZXqkNVf4-Se1-9LdzH_tnEflzw02w"
            }
        }
    }
}'
```
It should respond with `result: true`.


- Try if the access is allowed to admin with an expired/invalid token:

```
curl --location --request POST 'http://localhost:8181/v1/data/esamwad/backend/admin_console/allow' \
--header 'Content-Type: application/json' \
--data-raw '{
    "input": {
        "request": {
            "method": "GET",
            "path": "/api/v5/assessment/invalidate",
            "headers": {
                "authorization": "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlVVdzVZdVFWNnd2R29PdmZYNHBxWTdwS18zbyJ9.eyJhdWQiOiI3NzYzODg0Ny1kYjM0LTQzMzEtYjM2OS01NzY4ZmRmZWRlZGQiLCJleHAiOjE2NzE3OTY1NTksImlhdCI6MTY3MTcxMDE1OSwiaXNzIjoiYWNtZS5jb20iLCJzdWIiOiIxNTgyOWVhNC1kNTdhLTRjNTItODU5ZS0wNTkwMDFjNjFiZmIiLCJqdGkiOiJhYzM3ZTA2Yy1kMzhiLTRkMjQtYjVlNS01MjM0ZWNkMGUxMDQiLCJhdXRoZW50aWNhdGlvblR5cGUiOiJSRUZSRVNIX1RPS0VOIiwiZW1haWwiOiJzYW1hcnRoLWFkbWluQGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJzYW1hcnRoLWFkbWluIiwiYXBwbGljYXRpb25JZCI6Ijc3NjM4ODQ3LWRiMzQtNDMzMS1iMzY5LTU3NjhmZGZlZGVkZCIsInJvbGVzIjpbIkFkbWluIl0sImh0dHBzOi8vaGFzdXJhLmlvL2p3dC9jbGFpbXMiOnsieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJTdGF0ZSBBZG1pbiIsIkRpc3RyaWN0IEFkbWluIiwiQmxvY2sgQWRtaW4iLCJTY2hvb2wgQWRtaW4iLCJBZG1pbiJdLCJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJBZG1pbiJ9fQ.RxdlcuAKUOX_l3asikc0007EBeteSmZz4EosEv86PzpdwcDFbJgEnPf8SH6oivwq4k-VWiNEFEmFhfKSdo9nr5TlUJXhhRz3MpvmcyawAwUQgGGx0-YilM--fi9t6tSJwbJf68lkQ3k4uNOkZfGfnXoYoT4GyIolej7ZcIWuUeK6O6F5yC7hX9ucULiC3bAHQ5QHIUKn01c2AKjGI4BTf-eKWFqGfEwAwZ_b-m04TI02OtYN2iJPSJewNHCr8ZHPeVgsgBptLgZMXZh9qllLZWvft7M_6Qjc7PwqG3WuaMgEydkp_69K3TidlCb74qYvlzYF-gD2ghq5-xrfAnDvOg"
            }
        }
    }
}'
```
It should respond with `result: false`.