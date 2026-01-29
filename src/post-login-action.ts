// followed instructions here
// https://dev.to/emmamoinat/building-auth0-actions-in-typescript-20p0
import type { Event, PostLoginAPI } from "@auth0/actions/src/post-login/v3";

import axios from "axios";

export const onExecutePostLogin = async (event: Event, api: PostLoginAPI) => {
  const namespace = "https://www.cooldomain.com";

  const response = await axios.get(
    "https://jsonplaceholder.typicode.com/todos/1",
  );
  const data = response.data;

  if (event.authorization) {
    api.idToken.setCustomClaim(`${namespace}/roles`, event.authorization.roles);
    api.accessToken.setCustomClaim(
      `${namespace}/roles`,
      event.authorization.roles,
    );
    api.accessToken.setCustomClaim(`${namespace}/todo`, JSON.stringify(data));
  }
};

// @TODO what if I need external dependencies, i.e. axios?
