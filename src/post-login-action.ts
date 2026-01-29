// followed instructions here
// https://dev.to/emmamoinat/building-auth0-actions-in-typescript-20p0
import type { Event, PostLoginAPI } from "@auth0/actions/src/post-login/v3";

export const onExecutePostLogin = async (event: Event, api: PostLoginAPI) => {
  const namespace = "https://www.cooldomain.com";

  console.log(event);

  if (event.authorization) {
    api.idToken.setCustomClaim(`${namespace}/roles`, event.authorization.roles);
    api.accessToken.setCustomClaim(
      `${namespace}/roles`,
      event.authorization.roles,
    );
  }
};

// @TODO what if I need external dependencies, i.e. axios?
