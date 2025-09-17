package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.models.reporting.ReportOrder;
import spoton.errors.SpotOnException;

/**
 * ReportingEndpoint provides access to SpotOn's Reporting API endpoints.
 * This includes historical order data and reporting functionality.
 */
class ReportingEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new ReportingEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Retrieves historical order data for a specific location
     * @param locationId The location ID to get orders for
     * @param callback Callback function that receives an array of ReportOrder objects
     * @throws SpotOnException if the request fails or parameters are invalid
     */
    public function getOrders(locationId: String, callback: Array<ReportOrder> -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new SpotOnException("Location ID is required", "INVALID_LOCATION_ID");
        }
        
        // Construct the API path
        var path = '/reporting/v1/locations/${locationId}/orders';
        
        // Make the GET request
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            try {
                // Parse the response into an array of ReportOrder objects
                var orders: Array<ReportOrder> = [];
                
                if (response != null) {
                    // Handle both array response and object with data property
                    var orderData: Array<Dynamic> = null;
                    
                    if (Std.isOfType(response, Array)) {
                        orderData = cast response;
                    } else if (response.data != null && Std.isOfType(response.data, Array)) {
                        orderData = cast response.data;
                    } else if (response.orders != null && Std.isOfType(response.orders, Array)) {
                        orderData = cast response.orders;
                    }
                    
                    if (orderData != null) {
                        for (orderItem in orderData) {
                            if (orderItem != null) {
                                var order: ReportOrder = {
                                    id: orderItem.id,
                                    location_id: orderItem.location_id,
                                    source: orderItem.source,
                                    fulfillment_type: orderItem.fulfillment_type,
                                    created_at: orderItem.created_at != null ? Date.fromString(orderItem.created_at) : null
                                };
                                orders.push(order);
                            }
                        }
                    }
                }
                
                // Call the callback with the parsed orders
                callback(orders);
                
            } catch (e: Dynamic) {
                throw new SpotOnException("Failed to parse orders response: " + Std.string(e), "ORDERS_PARSE_ERROR", e);
            }
        });
    }
}