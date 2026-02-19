// followed instructions here
// https://dev.to/emmamoinat/building-auth0-actions-in-typescript-20p0
// @ts-ignore - types resolved at runtime in Auth0 Actions environment
import type { Event, PostLoginAPI } from "@auth0/actions/post-login/v3";

export const onExecutePreRegistration = async (
  event: Event,
  api: PostLoginAPI,
) => {
  const FORM_ID = event.secrets.PROGRESSIVE_PROFILE_FORM_ID;

  if (FORM_ID) {
    api.prompt.render(FORM_ID);
  }
};
