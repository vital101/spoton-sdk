package spoton.models.orders;

/**
 * OrderFulfillment typedef representing fulfillment information for orders
 * Contains details about how the order will be fulfilled and its scheduling
 */
typedef OrderFulfillment = {
    /**
     * Type of fulfillment (dine-in, pickup, delivery)
     */
    var type: FulfillmentType;
    
    /**
     * Schedule type for the fulfillment (e.g., "ASAP", "SCHEDULED")
     */
    var schedule_type: String;
    
    /**
     * Current status of the fulfillment
     */
    var status: String;
}