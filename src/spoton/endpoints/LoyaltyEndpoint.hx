package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.models.loyalty.Customer;
import spoton.models.loyalty.LocationStatus;

/**
 * LoyaltyEndpoint provides access to SpotOn's Loyalty API endpoints.
 * This includes customer management, points, rewards, and loyalty transactions.
 */
class LoyaltyEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new LoyaltyEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Creates or updates a customer in the loyalty system
     * @param locationId The location ID where the customer should be upserted
     * @param customer The customer data to create or update
     * @param callback Callback function to handle the upserted customer response
     * @throws SpotOnException if the request fails or validation errors occur
     */
    public function upsertCustomer(locationId: String, customer: Customer, callback: Customer -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new spoton.errors.SpotOnException("Location ID is required for customer upsert", "MISSING_LOCATION_ID");
        }
        
        if (customer == null) {
            throw new spoton.errors.SpotOnException("Customer data is required for upsert", "MISSING_CUSTOMER_DATA");
        }
        
        // Validate customer has required fields
        validateParams(customer);
        
        // Construct the API path
        var path = '/loyalty/v1/locations/${locationId}/customers';
        
        // Make the POST request to upsert the customer
        makeRequest("POST", path, customer, function(response: Dynamic): Void {
            // Parse the response into a Customer object
            var upsertedCustomer: Customer = cast response;
            callback(upsertedCustomer);
        });
    }
    
    /**
     * Retrieves the loyalty status and configuration for a specific location
     * @param locationId The location ID to get loyalty status for
     * @param callback Callback function to handle the location status response
     * @throws SpotOnException if locationId is null or empty
     */
    public function getLocationStatus(locationId: String, callback: LocationStatus -> Void): Void {
        // Validate location ID parameter
        if (locationId == null || locationId.length == 0) {
            throw new spoton.errors.SpotOnException("Location ID cannot be null or empty", "INVALID_LOCATION_ID");
        }
        
        // Construct the API path
        var path = '/loyalty/v1/locations/${locationId}/status';
        
        // Make the GET request to retrieve location loyalty status
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            // Parse the response into a LocationStatus object
            var locationStatus: LocationStatus = cast response;
            callback(locationStatus);
        });
    }
}