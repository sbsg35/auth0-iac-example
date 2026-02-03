import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import { Auth0Provider } from "@auth0/auth0-react";

// const MICROSOFT_CLIENT_ID = "TpgN27oSNheBNKvuftqtJNmcbNDe3uVU";
const TESLA_CLIENT_ID = "rGOgGd77hAddDGIG7NtOeQzQbVYp4D0o";

const AUTH0_DOMAIN = "";
const AUTH0_AUDIENCE = "https://api.example.com";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Auth0Provider
      domain={AUTH0_DOMAIN}
      clientId={TESLA_CLIENT_ID}
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
