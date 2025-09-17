package spoton.models.orders;

/**
 * Enum representing the different types of order fulfillment methods available in the SpotOn system.
 * This determines how the customer will receive their order.
 */
enum FulfillmentType {
    /**
     * Customer will dine in at the restaurant
     */
    FULFILLMENT_TYPE_DINE_IN;
    
    /**
     * Customer will pick up the order from the restaurant
     */
    FULFILLMENT_TYPE_PICKUP;
    
    /**
     * Order will be delivered to the customer
     */
    FULFILLMENT_TYPE_DELIVERY;
}