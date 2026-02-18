import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import { Auth0Provider } from "@auth0/auth0-react";

// const NINE_CLIENT_ID = "TpgN27oSNheBNKvuftqtJNmcbNDe3uVU";
const STAN_CLIENT_ID = "0WqL3e9DRFAtgd9sONJqNSVgxUuuRp5H";

const AUTH0_DOMAIN = "https://auth.happynewyear.world";
const AUTH0_AUDIENCE = "https://api.happynewyear.world";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Auth0Provider
      domain={AUTH0_DOMAIN}
      clientId={STAN_CLIENT_ID}
      authorizationParams={{
        redirect_uri: `${window.location.origin}/callback`,
        audience: AUTH0_AUDIENCE,
      }}
      cacheLocation="localstorage"
    >
      <App />
    </Auth0Provider>
  </StrictMode>,
);
