// followed instructions here
// https://dev.to/emmamoinat/building-auth0-actions-in-typescript-20p0
import type { Event, PostLoginAPI } from "@auth0/actions/src/post-login/v3";

import axios from "axios";

export const onExecutePostLogin = async (event: Event, api: PostLoginAPI) => {
  const namespace = "https://www.microsoft.com.au";

  const response = await axios.get(
    "https://jsonplaceholder.typicode.com/todos/1",
  );
  const data = response.data?.userId;

  if (event.authorization) {
    api.accessToken.setCustomClaim(
      `${namespace}/meta_data`,
      JSON.stringify(data),
    );

    console.log("APP_METADATA", event.user.app_metadata);
    if (event.user.app_metadata?.tesla_entitlement) {
      api.accessToken.setCustomClaim(
        `${namespace}/tesla_entitlement`,
        event.user.app_metadata.tesla_entitlement,
      );
    }
  }
};
