# Using Auth0 CLI to Create Client Grants

# Using Auth0 CLI to Create Client Grants

auth0 login --scopes create:client_grants

--scopes create:client_grants - Requests the create:client_grants permission scope during login. This grants your CLI session the ability to create client grants in your Auth0 tenant.

Client grants authorize machine-to-machine (M2M) applications to access Auth0 Management APIs or your own APIs. They define which APIs a specific application can call and with what permissions (scopes).

client_grants determines which application can request tokens from a specific API

## Management API

- Each tenant has a single management API identified by
  the audience `https://YOUR_DOMAIN/api/v2/`
  It is used to manage the tenant.

# API

- You can create your own APIs in Auth0.
  Each API has its own unique identifier (audience).
- API is the "listener"
- e.g. `www.events.nine.com.au`
- add scopes here: read:events, create:events, delete:events

# Creating an application

- Application is like a passport

## M2M

- Used by machines
- Each app created has it's own client_id and client_secret
- Used to authenticate the app when calling an API
- Allows you to customise login experience
- E.g SPA
- E.g. M2M: server to server communication

## Generic app

- Used by humans
- Login screens
- E.g. Regular Web App, SPA

# Auth0 Terraform

```
# Create a machine-to-machine application on Auth0
export AUTH0_M2M_APP=$(auth0 apps create \
  --name "Auth0 Terraform Provider" \
  --description "Auth0 Terraform Provider M2M" \
  --type m2m \
  --reveal-secrets \
  --json | jq -r '. | {client_id: .client_id, client_secret: .client_secret}')

# Extract the client ID and client secret from the output.
export AUTH0_CLIENT_ID=$(echo $AUTH0_M2M_APP | jq -r '.client_id')
export AUTH0_CLIENT_SECRET=$(echo $AUTH0_M2M_APP | jq -r '.client_secret')
```

{
"client_id": "Lc4e0ZC9k7ATDM4Ot67E5p7m4dhigE6n",
"client_secret": "l70X-3d5iGkmKvZJ5lZpJu605TxvgwTzFNKKPUKNIVm6-0wdprFLOcYghn1LmdSN"
}

export AUTH0_CLIENT_ID="Lc4e0ZC9k7ATDM4Ot67E5p7m4dhigE6n"
export AUTH0_CLIENT_SECRET="l70X-3d5iGkmKvZJ5lZpJu605TxvgwTzFNKKPUKNIVm6-0wdprFLOcYghn1LmdSN"

## Allow the m2m app to call the management API

# Get the ID and IDENTIFIER fields of the Auth0 Management API

export AUTH0_MANAGEMENT_API_ID=$(auth0 apis list --json | jq -r 'map(select(.name == "Auth0 Management API"))[0].id')
export AUTH0_MANAGEMENT_API_IDENTIFIER=$(auth0 apis list --json | jq -r 'map(select(.name == "Auth0 Management API"))[0].identifier')

# Get the SCOPES to be authorized

export AUTH0_MANAGEMENT_API_SCOPES=$(auth0 apis scopes list $AUTH0_MANAGEMENT_API_ID --json | jq -r '.[].value' | jq -ncR '[inputs]')

# Authorize the Auth0 Terraform Provider application to use the Auth0 Management API

```
auth0 api post "client-grants" --data='{"client_id": "'$AUTH0_CLIENT_ID'", "audience": "'$AUTH0_MANAGEMENT_API_IDENTIFIER'", "scope":'$AUTH0_MANAGEMENT_API_SCOPES'}'
```

## definitions

callbacks: Where Auth0 redirects users after login
allowed_logout_urls: Where Auth0 redirects users after logout
allowed_origins: Which domains can make direct API calls to Auth0 from the browser (CORS)

## Notes

- When I create an auth0 spa application it has management api in the APIs section
- This allows user to get a management API token
- This token is very limited in what it can do

| Action                                       | API to Use                          |
| -------------------------------------------- | ----------------------------------- |
| A user logs in to Brand A                    | Authentication API                  |
| You want to get a list of all users          | Management API (via M2M token)      |
| A user wants to change their profile picture | Management API (via User-level JWT) |
| Your backend needs to verify a user          | You create a Custom API in Auth0    |
