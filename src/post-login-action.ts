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

export const onExecutePostLogin = async (event: Event, api: PostLoginAPI) => {
  const app_meta = event.user.app_metadata as AppMetadata;

  api.accessToken.setCustomClaim("entitlement", app_meta);
};
