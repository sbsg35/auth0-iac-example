// followed instructions here
// https://dev.to/emmamoinat/building-auth0-actions-in-typescript-20p0
// @ts-ignore - types resolved at runtime in Auth0 Actions environment
import type { Event, PostLoginAPI } from "@auth0/actions/post-login/v3";

type AppMetadata = {
  stan?: {
    sport_status?: "active" | "inactive";
    entertainment_status?: "active" | "inactive";
  };
  afr?: "paid" | "free";
  the_age?: "paid" | "free";
};

type Clients = "stan" | "nine_now" | "afr" | "the_age";

const clientEntitlementsMap: Record<Clients, string[]> = {
  stan: ["afr", "the_age"],
  nine_now: ["afr", "the_age", "stan"],
  afr: ["the_age", "stan"],
  the_age: [],
};

const getEntitlementsForClient = (
  clientName: Clients,
  appMeta: AppMetadata,
) => {
  const entitlements: Record<string, unknown> = {};
  const clientEntitlements = clientEntitlementsMap[clientName];

  clientEntitlements.forEach((entitlement) => {
    if (appMeta[entitlement as keyof AppMetadata]) {
      entitlements[entitlement] = appMeta[entitlement as keyof AppMetadata];
    }
  });

  return entitlements;
};

/**
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
 */
export const onExecutePostLogin = async (event: Event, api: PostLoginAPI) => {
  const FORM_ID = event.secrets.PROGRESSIVE_PROFILE_FORM_ID;

  if (!event.user.user_metadata.full_name && FORM_ID) {
    api.prompt.render(FORM_ID);
  }
};

export const onContinuePostLogin = async (event: Event, api: PostLoginAPI) => {
  const app_meta = event.user.app_metadata as AppMetadata;
  const clientName = event.client.name as Clients;

  const entitlements = getEntitlementsForClient(clientName, app_meta);

  const namespace = "https://login.nine.com.au/entitlements";

  api.accessToken.setCustomClaim(`${namespace}`, entitlements);
};
