# Auth0 Basics and Using Terraform to Create Auth0 Resources

Step by step guide to set up Auth0 with Terraform.

In this mock example, we have a single tenant with multiple clients: Nine SPA, Stan SPA, and a Machine-to-Machine (M2M) client each of these.
There is also an event api which the m2m client can call with appropriate scopes.

This will create the following resources in Auth0:

- Post Login Action
- Auth0 Applications (SPA Clients)
- Auth0 M2M Clients
- Auth0 APIs
- If you opt with a custom domain
  - Auth0 Custom Domain
  - Custom brand pages with universal login

## Table of Contents

- [Setting Up Auth0 with Terraform](#setting-up-auth0-with-terraform)
  - [Step 1: Login to Auth0 CLI](#step-1-login-to-auth0-cli)
  - [Step 2: Create a Machine-to-Machine Application](#step-2-create-a-machine-to-machine-application)
  - [Step 3: Allow the M2M App to Call the Management API](#step-3-allow-the-m2m-app-to-call-the-management-api)
  - [Step 4: Terraform apply](#step-4-terraform-apply)
- [Auth0 Actions](#auth0-actions)
  - [Building the post login action](#building-the-post-login-action)
  - [Deploying the post login action](#deploying-the-post-login-action)
  - [Actions docs](#actions-docs)
- [M2M tokens](#m2m-tokens)
- [Client side app](#client-side-app)

---

## Setting Up Auth0 with Terraform

## Prerequisites

- A paid Auth0 tenant (required for custom domains and branding). Alternatively, you can use a free tenant but skip the custom domain and branding steps.
- When you first sign up Auth0, you get a 21 day free trial of the paid features, so you can use that to follow along with all the steps.

### Step 1: Login to Auth0 CLI

Create an auth0 account and a tenant.

```bash
# install the cli
brew tap auth0/auth0-cli
brew install auth0

# login to auth0 cli with create:client_grants scope
auth0 login --scopes create:client_grants
```

`--scopes create:client_grants` - Requests the create:client_grants permission scope during login. This grants your CLI session the ability to create client grants in your Auth0 tenant.

### Step 2: Create a Machine-to-Machine Application

```bash
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

### Step 3: Allow the M2M App to Call the Management API

```bash
# Get the ID and IDENTIFIER fields of the Auth0 Management API
export AUTH0_MANAGEMENT_API_ID=$(auth0 apis list --json | jq -r 'map(select(.name == "Auth0 Management API"))[0].id')
export AUTH0_MANAGEMENT_API_IDENTIFIER=$(auth0 apis list --json | jq -r 'map(select(.name == "Auth0 Management API"))[0].identifier')

# Get the SCOPES to be authorized
export AUTH0_MANAGEMENT_API_SCOPES=$(auth0 apis scopes list $AUTH0_MANAGEMENT_API_ID --json | jq -r '.[].value' | jq -ncR '[inputs]')

# Authorize the Auth0 Terraform Provider application to use the Auth0 Management API
auth0 api post "client-grants" --data='{"client_id": "'$AUTH0_CLIENT_ID'", "audience": "'$AUTH0_MANAGEMENT_API_IDENTIFIER'", "scope":'$AUTH0_MANAGEMENT_API_SCOPES'}'
```

### Step 4: Terraform apply

In `terraform/variables.tf`, update the `auth0_domain` variable with your Auth0 domain.

Now you can terraform apply your Auth0 resources!

```bash
# Build the post-login action
npm run build
# Apply the terraform configuration
cd terraform/
terraform init
terraform apply
```

---

## Auth0 Actions

- Actions are functions that can be executed at certain points in the Auth0 flow
- There is one action called "Post Login"
- It needs to be built and deployed

### Building the post login action

```bash
npm run build
```

### Deploying the post login action

To deploy, use terraform apply in the terraform/ directory after building the action.

### Actions docs

User: what is the difference between event and api?

GitHub Copilot: Read [](file:///Users/sukhraj.ghuman/playground/auth0-iac/src/post-login-action.ts)

In Auth0 Actions, the `event` and `api` objects serve different purposes:

#### `event` (Read-Only Context)

The **event** object provides **read-only information** about the login attempt. It contains:

- **`event.user`** - Details about the user (email, metadata, identities)
- **`event.authorization`** - Info about the authorization (if successful)
- **`event.request`** - HTTP request details (IP, user agent, etc.)
- **`event.connection`** - The connection used to authenticate
- **`event.client`** - The application/client details

In your code, you're reading from it:

- `event.authorization` - checking if authorization exists
- `event.user.app_metadata?.stan_entitlement` - reading user metadata

#### `api` (Actions/Mutations)

The **api** object provides **methods to modify the authentication flow**. It lets you:

- **`api.accessToken.setCustomClaim()`** - Add custom claims to the access token
- **`api.idToken.setCustomClaim()`** - Add custom claims to the ID token
- **`api.user.setAppMetadata()`** - Update user's app metadata
- **`api.access.deny()`** - Deny the login
- **`api.redirect.sendUserTo()`** - Redirect the user mid-flow

In your code, you're using it to add custom claims:

- `api.accessToken.setCustomClaim()` - Adding the todo and stan_entitlement claims

#### Summary

| Aspect     | `event`            | `api`               |
| ---------- | ------------------ | ------------------- |
| Purpose    | **Read** context   | **Write** changes   |
| Mutability | Read-only          | Methods to modify   |
| Example    | Who is logging in? | What should happen? |

Think of `event` as "what happened" and `api` as "what to do about it."

## Client side app

```
cd app
npm install
npm run dev
```

In the app/src/main.tsx file, update the AUTH0_DOMAIN, AUTH0_AUDIENCE, and client IDs for the applications.

## Admin

- copy .env.example to .env and update the values with your Auth0 tenant and M2M app details.
- update-user-metadata.ts - script to update user metadata for a given user. This is useful for testing the post-login action with different user metadata values.

## Forms and flows

### Forms

- Forms is a visual editor that allows you to create customizable forms that can be used to extend your identity flows with additional steps and business logic.
- A controlled and secure experience within your tenant’s domain. No need to Redirect users to external sites.

use cases:

- Progressive profiling
- Custom policies acceptance (e.g. age verification, terms of service, etc.)
- Custom signup or login steps: verify email or phone numbers with OTP and account linking, or verify payment details with Stripe

### Flows

Below is copied from docs: https://auth0.com/docs/customize/forms/flows

- Flows allow you to visually build the server-side logic that can be executed within your Forms and handle the collected information, integrate any service with an API or trigger automations.
- Create custom server-side validations for your form steps.
- Integrate with your own API making custom HTTP requests.
- Integrate with 3rd parties using our out-of-the-box integrations.
- Execute different business logic based based on user input or properties.
- Validate data using JSON Web Tokens.
