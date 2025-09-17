package spoton.auth;

import spoton.errors.AuthenticationException;

/**
 * Basic implementation of AuthenticationManager for SpotOn API
 * Supports API key authentication with automatic header management
 */
class AuthenticationManagerImpl implements AuthenticationManager {
    private var credentials: Credentials;
    private var isAuthenticated: Bool = false;
    private var authHeaders: Map<String, String>;
    
    /**
     * Creates a new AuthenticationManager with the provided credentials
     * @param credentials The API credentials (API key or OAuth client credentials)
     */
    public function new(credentials: Credentials) {
        this.credentials = credentials;
        this.authHeaders = new Map<String, String>();
    }
    
    /**
     * Authenticates with the SpotOn API using provided credentials
     * For API key authentication, this validates the key format and prepares headers
     * @return true if authentication succeeds
     * @throws AuthenticationException if credentials are invalid or missing
     */
    public function authenticate(): Bool {
        // Reset authentication state
        isAuthenticated = false;
        authHeaders.clear();
        
        // Check for API key authentication
        if (credentials.apiKey != null) {
            return authenticateWithApiKey();
        }
        
        // Check for OAuth client credentials
        if (credentials.clientId != null && credentials.clientSecret != null) {
            // OAuth implementation would go here in future iterations
            // This would handle token retrieval and automatic refresh (Requirement 5.2)
            throw new AuthenticationException("OAuth authentication not yet implemented", "OAUTH_NOT_IMPLEMENTED");
        }
        
        // No valid credentials provided
        throw new AuthenticationException("No valid credentials provided. Please provide either apiKey or clientId/clientSecret", "MISSING_CREDENTIALS");
    }
    
    /**
     * Gets the authentication headers required for API requests
     * Must call authenticate() first before using this method
     * @return Map of header names to header values for authorization
     * @throws AuthenticationException if not authenticated
     */
    public function getAuthHeaders(): Map<String, String> {
        if (!isAuthenticated) {
            throw new AuthenticationException("Not authenticated. Call authenticate() first", "NOT_AUTHENTICATED");
        }
        
        return authHeaders.copy();
    }
    
    /**
     * Handles API key authentication
     * @return true if API key authentication succeeds
     * @throws AuthenticationException if API key is invalid
     */
    private function authenticateWithApiKey(): Bool {
        var apiKey = credentials.apiKey;
        
        // Basic validation of API key format
        if (apiKey == null || apiKey.length == 0) {
            throw new AuthenticationException("API key cannot be empty", "INVALID_API_KEY");
        }
        
        // API key should be a reasonable length (basic validation)
        if (apiKey.length < 10) {
            throw new AuthenticationException("API key appears to be too short", "INVALID_API_KEY");
        }
        
        // Set up authorization header for API key authentication
        // SpotOn API typically uses Bearer token format
        authHeaders.set("Authorization", "Bearer " + apiKey);
        authHeaders.set("Content-Type", "application/json");
        
        isAuthenticated = true;
        return true;
    }
    
    /**
     * Checks if the manager is currently authenticated
     * @return true if authenticated, false otherwise
     */
    public function isAuthenticatedStatus(): Bool {
        return isAuthenticated;
    }
    
    /**
     * Refreshes the authentication token if needed
     * For API key authentication, this is a no-op since API keys don't expire
     * For OAuth authentication, this would refresh the access token
     * @return true if refresh succeeds or is not needed
     * @throws AuthenticationException if refresh fails
     */
    public function refreshTokenIfNeeded(): Bool {
        if (!isAuthenticated) {
            throw new AuthenticationException("Cannot refresh token when not authenticated", "NOT_AUTHENTICATED");
        }
        
        // For API key authentication, no refresh is needed
        if (credentials.apiKey != null) {
            return true;
        }
        
        // OAuth token refresh would be implemented here in future iterations
        // This addresses Requirement 5.2 for automatic token refresh
        throw new AuthenticationException("Token refresh not implemented for OAuth", "REFRESH_NOT_IMPLEMENTED");
    }
}