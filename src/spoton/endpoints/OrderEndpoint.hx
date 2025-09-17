package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.models.orders.Order;

/**
 * OrderEndpoint provides methods for interacting with SpotOn's Order API.
 * This includes order submission, proposal, cancellation, and status management.
 */
class OrderEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new OrderEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Submits an order to SpotOn for processing
     * @param locationId The location ID where the order should be submitted
     * @param order The order data to submit
     * @param callback Callback function to handle the submitted order response
     * @throws SpotOnException if the request fails or validation errors occur
     */
    public function submitOrder(locationId: String, order: Order, callback: Order -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new spoton.errors.SpotOnException("Location ID is required for order submission", "MISSING_LOCATION_ID");
        }
        
        if (order == null) {
            throw new spoton.errors.SpotOnException("Order data is required for submission", "MISSING_ORDER_DATA");
        }
        
        // Validate order has required fields
        validateParams(order);
        
        // Construct the API path
        var path = '/order/v1/locations/${locationId}/orders';
        
        // Make the POST request to submit the order
        makeRequest("POST", path, order, function(response: Dynamic): Void {
            // Parse the response into an Order object
            var submittedOrder: Order = cast response;
            callback(submittedOrder);
        });
    }
    
    /**
     * Cancels an existing order
     * @param locationId The location ID where the order exists
     * @param orderId The ID of the order to cancel
     * @param callback Callback function to handle the cancellation response
     * @throws SpotOnException if the request fails or validation errors occur
     */
    public function cancelOrder(locationId: String, orderId: String, callback: Dynamic -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new spoton.errors.SpotOnException("Location ID is required for order cancellation", "MISSING_LOCATION_ID");
        }
        
        if (orderId == null || orderId.length == 0) {
            throw new spoton.errors.SpotOnException("Order ID is required for order cancellation", "MISSING_ORDER_ID");
        }
        
        // Construct the API path
        var path = '/order/v1/locations/${locationId}/orders/${orderId}/cancel';
        
        // Make the POST request to cancel the order
        makeRequest("POST", path, null, function(response: Dynamic): Void {
            // Return the cancellation response
            callback(response);
        });
    }
}