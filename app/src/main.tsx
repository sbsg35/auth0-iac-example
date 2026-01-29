import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import { Auth0Provider } from "@auth0/auth0-react";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Auth0Provider
      domain="dev-sjjgeg1szb3x4yy2.au.auth0.com"
      clientId="sSdKg7Vg9Lkru5XNzrLkXx3KdjUZ8oXA"
      authorizationParams={{
        redirect_uri: `${window.location.origin}/callback`,
        audience: "https://dev-sjjgeg1szb3x4yy2.au.auth0.com/api/v2/",
      }}
      cacheLocation="localstorage"
    >
      <App />
    </Auth0Provider>
  </StrictMode>,
);
