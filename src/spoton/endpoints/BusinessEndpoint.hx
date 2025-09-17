package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;

/**
 * BusinessEndpoint provides access to SpotOn's Business API endpoints.
 * This includes location information and liveness checks.
 */
class BusinessEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new BusinessEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Checks the liveness/health status of the SpotOn Business API
     * This endpoint is typically used for health checks and monitoring
     * @param callback Callback function to handle the liveness response
     */
    public function getLiveness(callback: Dynamic -> Void): Void {
        makeRequest("GET", "/business/v1/livez", null, callback);
    }
    
    /**
     * Retrieves location information for a specific SpotOn business location
     * @param locationId The unique identifier for the location (format: BL-XXXX-XXXX-XXXX)
     * @param callback Callback function to handle the location response
     * @throws SpotOnException if locationId is null or empty
     */
    public function getLocation(locationId: String, callback: Dynamic -> Void): Void {
        // Validate location ID parameter
        if (locationId == null || locationId.length == 0) {
            throw new spoton.errors.SpotOnException("Location ID cannot be null or empty", "INVALID_LOCATION_ID");
        }
        
        // Construct the API path with the location ID
        var path = "/business/v1/locations/" + locationId;
        
        // Make the GET request to retrieve location information
        makeRequest("GET", path, null, callback);
    }
}