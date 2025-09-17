package spoton.auth;

/**
 * Interface for authentication management in the SpotOn SDK
 * Handles API authentication and provides authorization headers
 */
interface AuthenticationManager {
    /**
     * Authenticates with the SpotOn API using provided credentials
     * @return Promise that resolves to true if authentication succeeds
     */
    function authenticate(): Bool;
    
    /**
     * Gets the authentication headers required for API requests
     * @return Map of header names to header values for authorization
     */
    function getAuthHeaders(): Map<String, String>;
}