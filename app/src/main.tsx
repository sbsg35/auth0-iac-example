import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import { Auth0Provider } from "@auth0/auth0-react";

const clients = {
  stan: {
    clientId: "nhoYvpvsv2Y1y4u74YmbHdp4GzapwpE2",
  },
  nine: {
    clientId: "sSdKg7Vg9Lkru5XNzrLkXx3KdjUZ8oXA",
  },
};

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Auth0Provider
      domain="login.happynewyear.world"
      clientId={clients.stan.clientId}
      authorizationParams={{
        redirect_uri: `${window.location.origin}/callback`,
        audience: "https://api.happynewyear.world",
      }}
      cacheLocation="localstorage"
    >
      <App />
    </Auth0Provider>
  </StrictMode>,
);
