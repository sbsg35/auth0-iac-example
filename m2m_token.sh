#!/bin/bash

# Use this script to obtain a machine-to-machine access token from an OAuth 2.0 authorization server. Fully replace the placeholder values below before running.

CLIENT_ID=""
CLIENT_SECRET=""
AUDIENCE=""
DOMAIN=""

curl --location "https://$DOMAIN/oauth/token" \
--header 'Content-Type: application/json' \
--data '{
    "client_id": "'$CLIENT_ID'",
    "client_secret": "'$CLIENT_SECRET'",
    "audience": "'$AUDIENCE'",
    "grant_type": "client_credentials"
}'