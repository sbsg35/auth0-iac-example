// Classic Universal Login - Lock Configuration
// This will be inlined in the HTML template

declare var Auth0Lock: any;

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
const NINE_NOW_CLIENT_ID = "sSdKg7Vg9Lkru5XNzrLkXx3KdjUZ8oXA";
const STAN_CLIENT_ID = "nhoYvpvsv2Y1y4u74YmbHdp4GzapwpE2";

// Theme configurations
const themes = {
  nine_now: {
    primaryColor: "#1abeff",
    logo: "https://uat.login.nine.com.au/client-images/themes/9now/client-logo.svg?v=1611008630764",
    background:
      "linear-gradient(135deg, #0a1628 0%, #0d2137 50%, #1abeff 100%)",
  },
  stan: {
    primaryColor: "#0072fb",
    logo: "https://www.nineforbrands.com.au/wp-content/uploads/2020/07/Stan.jpg",
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
  if (config.clientID === NINE_NOW_CLIENT_ID) {
    theme = themes.nine_now;
  } else if (config.clientID === STAN_CLIENT_ID) {
    theme = themes.stan;
  }

  // Apply background
  document.body.style.background = theme.background;

  // Base Lock options
  const lockOptions = {
    auth: {
      redirectUrl: config.callbackURL,
      responseType:
        (config.internalOptions || {}).response_type ||
        (config.callbackOnLocationHash ? "token" : "code"),
      params: config.internalOptions,
    },
    configurationBaseUrl: config.clientConfigurationBaseUrl,
    overrides: {
      __tenant: config.auth0Tenant,
      __token_issuer: config.authorizationServer.issuer,
    },
    assetsUrl: config.assetsUrl,
    allowedConnections: config.connection ? [config.connection] : null,
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
