# Auth0 basics and using terraform to create Auth0 resources

## Using Auth0 CLI to Create Client Grants

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

## Auth0 Managed Certs Flow

─────────────────────────────────────────────────────────────────────────────┐
│ RUNTIME FLOW (Every login) │
└─────────────────────────────────────────────────────────────────────────────┘

User visits your app → Clicks "Login" → Redirected to auth.happynewyear.world

    ┌────────┐         ┌────────────┐         ┌─────────────────┐
    │  User  │ ──DNS──→│ Your DNS   │ ──→     │ CNAME resolves  │
    │Browser │         │ Provider   │         │ to Auth0 edge   │
    └────────┘         └────────────┘         └─────────────────┘
         │                                            │
         │                                            ▼
         │                                   ┌─────────────────┐
         │                                   │  Auth0's Edge   │
         │                                   │    Server       │
         │                                   │ (has your cert) │
         │                                   └─────────────────┘
         │                                            │
         │◄───────────── HTTPS Response ──────────────┘
         │               (SSL with your cert for
         │                auth.happynewyear.world)
         ▼
    ┌────────┐
    │ User   │  Sees: 🔒 auth.happynewyear.world
    │ Browser│  Login page loads securely
    └────────┘

Why You Need a Custom API for custom domains
The Problem
When you call getAccessTokenSilently() without an audience:

Auth0 returns an opaque (encrypted) token
This token is only for Auth0's internal use (userinfo endpoint)
You cannot decode it - it's encrypted, not signed
The Solution
When you specify an audience (API identifier):

Auth0 returns a JWT (JSON Web Token)
The JWT is signed (not encrypted) - you can decode and verify it
It contains claims about the user and their permissions
The Flow
What the Custom API Represents
The auth0_resource_server (API) represents your backend service:

The identifier (https://api.happynewyear.world) doesn't need to be a real URL - it's just a unique identifier that:

Your frontend requests tokens for
Your backend validates tokens against
JWT Structure (What You Get)
Why skip_consent_for_verifiable_first_party_clients?
Without it, Auth0 shows a consent screen:

"9Now App wants to access Happy New Year API. Allow?"

This makes sense for third-party apps but not for your own apps. Setting this to true skips the prompt for your first-party clients.

Summary: The custom API tells Auth0 "issue a JWT that my backend can validate" instead of an opaque token only Auth0 can use.

The API doesn't matter much at all

The API identifier (https://api.happynewyear.world) is just a unique string - it's not an actual URL that Auth0 calls.

What it's actually used for:

```
┌─────────────────────────────────────────────────────────────────┐
│                      IT'S JUST A LABEL                          │
└─────────────────────────────────────────────────────────────────┘

Frontend (React):
  audience: "https://api.happynewyear.world"
      │
      ▼
Auth0: "Ah, they want a token FOR 'https://api.happynewyear.world'"
      │
      ▼
JWT contains:
  {
    "aud": "https://api.happynewyear.world",  ← Just a string in the token
    ...
  }
```

You could use anything:

```
# All of these would work:
identifier = "https://api.happynewyear.world"  # Looks like URL (convention)
identifier = "my-cool-api"                      # Plain string
identifier = "urn:my-api:production"            # URN format
identifier = "happynewyear-api"                 # Whatever you want
```

# All of these would work:identifier = "https://api.happynewyear.world"  # Looks like URL (convention)identifier = "my-cool-api"                      # Plain stringidentifier = "urn:my-api:production"            # URN formatidentifier = "happynewyear-api"                 # Whatever you want
When would you actually use it?
IF you build a backend later, you'd validate incoming JWTs:

```
// Backend (hypothetical)
const decoded = verifyJWT(token);
if (decoded.aud !== "https://api.happynewyear.world") {
  throw new Error("Token not intended for this API");
}
```

# Auth0 m2m clients with API

Great question! It depends on **who/what** is calling your API:

## Scenario 1: Users from different brands (SPA/Web Apps)

**Each brand = separate SPA client, same API**

```
┌─────────────────┐     ┌─────────────────┐
│   9Now App      │     │   Stan App      │
│   (SPA Client)  │     │   (SPA Client)  │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │  User logs in         │  User logs in
         │  Gets JWT with        │  Gets JWT with
         │  aud: "my-api"        │  aud: "my-api"
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
          ┌─────────────────────┐
          │     Your API        │
          │  (One API resource) │
          └─────────────────────┘
```

**No M2M needed** - users authenticate via SPA clients.

---

## Scenario 2: Backend services calling your API (M2M)

**Each service = separate M2M client**

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  9Now Backend   │     │  Stan Backend   │     │  Analytics Svc  │
│  (M2M Client)   │     │  (M2M Client)   │     │  (M2M Client)   │
└────────┬────────┘     └────────┬────────┘     └────────┬────────┘
         │                       │                       │
         │ client_credentials    │ client_credentials    │ client_credentials
         │ grant                 │ grant                 │ grant
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                                 ▼
                      ┌─────────────────────┐
                      │     Your API        │
                      │  (One API resource) │
                      └─────────────────────┘
```

**Yes, separate M2M apps** - each backend service gets its own `client_id` + `client_secret`.

---

## Why separate M2M apps per service?

| Reason                 | Benefit                                                         |
| ---------------------- | --------------------------------------------------------------- |
| **Security isolation** | Revoke one service without affecting others                     |
| **Different scopes**   | 9Now backend gets `read:content`, Analytics gets `read:metrics` |
| **Audit trail**        | Know which service made which API call                          |
| **Rate limiting**      | Apply different limits per service                              |

---

## Your Current Setup

```
┌─────────────────────────────────────────────────────────────────┐
│                        Your Auth0 Tenant                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  SPA Clients (for users):          API:                         │
│  ┌─────────────┐ ┌─────────────┐   ┌─────────────────────────┐ │
│  │ 9Now Client │ │ Stan Client │   │ api.happynewyear.world  │ │
│  └─────────────┘ └─────────────┘   └─────────────────────────┘ │
│                                                                 │
│  M2M Clients (for backends):       Management API:              │
│  ┌─────────────────────────────┐   ┌─────────────────────────┐ │
│  │ Terraform Provider (M2M)   │   │ Auth0 Management API    │ │
│  └─────────────────────────────┘   └─────────────────────────┘ │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Summary:**

- **Users** → SPA clients (9Now, Stan) → Your API
- **Backend services** → M2M clients (one per service) → Your API or Management API
  ┌─────────────────┐ ┌─────────────────┐
  │ 9Now App │ │ Stan App │
  │ (SPA Client) │ │ (SPA Client) │
  └────────┬────────┘ └────────┬────────┘
  │ │
  │ User logs in │ User logs in
  │ Gets JWT with │ Gets JWT with
  │ aud: "my-api" │ aud: "my-api"
  │ │
  └───────────┬───────────┘
  │
  ▼
  ┌─────────────────────┐
  │ Your API │
  │ (One API resource) │
  └─────────────────────┘
