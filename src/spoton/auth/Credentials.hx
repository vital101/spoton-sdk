package spoton.auth;

/**
 * Credentials typedef for SpotOn API authentication
 * Supports API key authentication or OAuth client credentials
 */
typedef Credentials = {
    /**
     * API key for simple authentication
     */
    ?apiKey: String,
    
    /**
     * Client ID for OAuth authentication
     */
    ?clientId: String,
    
    /**
     * Client secret for OAuth authentication
     */
    ?clientSecret: String
}