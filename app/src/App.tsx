import { useAuth0 } from "@auth0/auth0-react";
import { jwtDecode } from "jwt-decode";
import { useState } from "react";

function App() {
  const {
    isLoading,
    isAuthenticated,
    error,
    user,
    loginWithRedirect,
    logout,
    getAccessTokenSilently,
  } = useAuth0();

  const [accessToken, setAccessToken] = useState<string>("");
  const [decodedToken, setDecodedToken] = useState<unknown>(null);

  const fetchAccessToken = async () => {
    try {
      const token = await getAccessTokenSilently();
      console.log("Token received:", token);
      setAccessToken(token);
      const decoded = jwtDecode(token);
      console.log("Decoded token:", decoded);
      setDecodedToken(decoded);
    } catch (err: unknown) {
      console.error("Error getting access token:", err);
    }
  };

  if (isLoading) {
    return <div>Loading...</div>;
  }
  if (error) {
    return <div>Oops... {error.message}</div>;
  }

  if (isAuthenticated && !user?.email_verified) {
    return (
      <div>
        Your email is not verified!
        <button
          onClick={() =>
            logout({ logoutParams: { returnTo: window.location.origin } })
          }
        >
          Logout
        </button>
      </div>
    );
  }

  if (isAuthenticated) {
    return (
      <div style={{ padding: "20px", fontFamily: "sans-serif" }}>
        <div style={{ marginBottom: "20px" }}>
          <h2>Hello {user?.name}!</h2>
          <button
            onClick={fetchAccessToken}
            style={{
              padding: "10px 20px",
              background: "#19BEFF",
              color: "white",
              border: "none",
              borderRadius: "5px",
              cursor: "pointer",
              marginRight: "10px",
            }}
          >
            Get Access Token
          </button>
          <button
            onClick={() =>
              logout({ logoutParams: { returnTo: window.location.origin } })
            }
            style={{
              padding: "10px 20px",
              background: "#d62828",
              color: "white",
              border: "none",
              borderRadius: "5px",
              cursor: "pointer",
            }}
          >
            Log out
          </button>
        </div>

        {accessToken && (
          <>
            <div style={{ marginBottom: "30px" }}>
              <h3>Access Token (Raw):</h3>
              <pre
                style={{
                  background: "#f5f5f5",
                  padding: "15px",
                  borderRadius: "5px",
                  overflow: "auto",
                  fontSize: "12px",
                  wordBreak: "break-all",
                  whiteSpace: "pre-wrap",
                }}
              >
                {accessToken}
              </pre>
            </div>

            <div>
              <h3>Access Token (Decoded):</h3>
              <pre
                style={{
                  background: "#f5f5f5",
                  padding: "15px",
                  borderRadius: "5px",
                  overflow: "auto",
                  fontSize: "14px",
                }}
              >
                {JSON.stringify(decodedToken, null, 2)}
              </pre>
            </div>
          </>
        )}
      </div>
    );
  } else {
    return (
      <>
        <button onClick={() => loginWithRedirect()}>Log in</button>
        <button
          onClick={() =>
            loginWithRedirect({
              authorizationParams: { screen_hint: "signup" },
            })
          }
        >
          Sign up
        </button>
      </>
    );
  }
}

export default App;
