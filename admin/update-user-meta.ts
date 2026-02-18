// This script updates the app_metadata of a user in Auth0
import { ManagementClient } from "auth0";

const USER_ID = "auth0|69943925793819a27d4ecb02";

const auth0 = new ManagementClient({
  domain: "nine-trx.au.auth0.com",
  clientId: process.env.AUTH0_CLIENT_ID!,
  clientSecret: process.env.AUTH0_CLIENT_SECRET!,
});

auth0.users
  .update(USER_ID, {
    app_metadata: {
      afr: "paid",
      the_age: "free",
      stan: {
        sport: "active",
        entertainment: "inactive",
      },
    },
  })
  .then((d) => console.log(JSON.stringify(d, null, 2)))
  .catch(console.error);

// use below to remove fields from app_metadata
// auth0.users
//   .update(USER_ID, {
//     app_metadata: {
//       afr: null, // setting this to null will remove this field
//       the_age: null, // setting this to null will remove this field
//       stan: null, // setting this to null will remove this field
//     },
//   })
//   .then((d) => console.log(JSON.stringify(d, null, 2)))
//   .catch(console.error);
