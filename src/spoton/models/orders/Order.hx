package spoton.models.orders;

/**
 * Order typedef representing a complete order in the SpotOn system
 * Contains all information about an order including items, customer, fulfillment, and totals
 */
typedef Order = {
    /**
     * Unique SpotOn order identifier
     */
    var id: String;
    
    /**
     * External reference ID from the originating system
     */
    var external_reference_id: String;
    
    /**
     * Location ID where the order is placed
     */
    var location_id: String;
    
    /**
     * Array of items in the order
     */
    var line_items: Array<OrderItem>;
    
    /**
     * Current state of the order
     */
    var state: OrderState;
    
    /**
     * Source system or channel where the order originated
     */
    var source: OrderSource;
    
    /**
     * Customer information for the order
     */
    var customer: OrderCustomer;
    
    /**
     * Fulfillment details for the order
     */
    var fulfillment: OrderFulfillment;
    
    /**
     * Financial totals for the order
     */
    var totals: OrderTotals;
    
    /**
     * Menu ID associated with the order
     */
    var menu_id: String;
}