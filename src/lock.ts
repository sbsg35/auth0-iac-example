// Classic Universal Login - Lock Configuration
// This will be inlined in the HTML template

import Auth0Lock from "auth0-lock";

interface Auth0Config {
  clientID: string;
  auth0Domain: string;
  callbackURL: string;
  callbackOnLocationHash: boolean;
  internalOptions: any;
  clientConfigurationBaseUrl: string;
  auth0Tenant: string;
  authorizationServer: {
    issuer: string;
  };
  assetsUrl: string;
  connection?: string;
  prompt?: {
    name: string;
  };
  language: string;
  languageBaseUrl: string;
  dict: any;
}

// Client IDs
const MICROSOFT_CLIENT_ID = "sSdKg7Vg9Lkru5XNzrLkXx3KdjUZ8oXA";
const TESLA_CLIENT_ID = "nhoYvpvsv2Y1y4u74YmbHdp4GzapwpE2";

// Theme configurations
const themes = {
  microsoft: {
    primaryColor: "#1abeff",
    logo: "https://cdn.brandfetch.io/idchmboHEZ/theme/dark/symbol.svg?c=1dxbfHSJFAPEGdCLU4o5B",
    background:
      "linear-gradient(135deg, #0a1628 0%, #0d2137 50%, #1abeff 100%)",
  },
  tesla: {
    primaryColor: "#0072fb",
    logo: "https://upload.wikimedia.org/wikipedia/commons/b/bd/Tesla_Motors.svg",
    background:
      "linear-gradient(135deg, #001d3d 0%, #003566 50%, #0072fb 100%)",
  },
  default: {
    primaryColor: "#635dff",
    logo: "",
    background:
      "linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%)",
  },
};

export function initLock(config: Auth0Config) {
  // Determine theme based on clientID
  let theme = themes.default;
  if (config.clientID === MICROSOFT_CLIENT_ID) {
    theme = themes.microsoft;
  } else if (config.clientID === TESLA_CLIENT_ID) {
    theme = themes.tesla;
  }

  // Apply background
  document.body.style.background = theme.background;

  // Base Lock options
  const lockOptions: Auth0LockConstructorOptions = {
    auth: {
      redirectUrl: config.callbackURL,
      responseType:
        (config.internalOptions || {}).response_type ||
        (config.callbackOnLocationHash ? "token" : "code"),
      params: config.internalOptions,
    },
    configurationBaseUrl: config.clientConfigurationBaseUrl,
    assetsUrl: config.assetsUrl,
    rememberLastLogin: !config.prompt || config.prompt.name !== "login",
    language: config.language,
    languageBaseUrl: config.languageBaseUrl,
    languageDictionary: config.dict,
    closable: false,
    defaultADUsernameFromEmailPrefix: false,
    theme: {
      primaryColor: theme.primaryColor,
      logo: theme.logo,
      authButtons: {
        "google-oauth2": {
          displayName: "Continue with Google",
          primaryColor: "#FFFFFF",
          foregroundColor: "#000000",
        },
      },
    },
  };

  const lock = new Auth0Lock(config.clientID, config.auth0Domain, lockOptions);
  lock.show();
}
