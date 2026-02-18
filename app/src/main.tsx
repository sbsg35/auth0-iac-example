import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App.tsx";
import { Auth0Provider } from "@auth0/auth0-react";

// const CLIENT_ID = "N76IgpGHOusDtP2XjrHx7ft6FDy8A6x9"; // nine_now client id
// const CLIENT_ID = "0WqL3e9DRFAtgd9sONJqNSVgxUuuRp5H"; // stan client id
const CLIENT_ID = "75C7d6zJYJL6QQHIXeL9XoYMVgG8nQ6N"; // afr client id

const AUTH0_DOMAIN = "https://auth.happynewyear.world";
const AUTH0_AUDIENCE = "https://api.happynewyear.world";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Auth0Provider
      domain={AUTH0_DOMAIN}
      clientId={CLIENT_ID}
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
