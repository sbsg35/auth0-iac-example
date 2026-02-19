// This script updates the app_metadata of a user in Auth0
import { ManagementClient } from "auth0";

const USER_ID = "auth0|69943925793819a27d4ecb02";
const AUTH0_DOMAIN = "nine-trx.au.auth0.com";

const auth0 = new ManagementClient({
  domain: AUTH0_DOMAIN,
  clientId: process.env.AUTH0_CLIENT_ID!,
  clientSecret: process.env.AUTH0_CLIENT_SECRET!,
});

auth0.users
  .get(USER_ID, {})
  .then((user) => console.log(JSON.stringify(user, null, 2)))
  .catch(console.error);
