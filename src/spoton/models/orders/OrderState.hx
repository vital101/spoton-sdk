package spoton.models.orders;

/**
 * Enum representing the various states an order can be in within the SpotOn system.
 * These states track the lifecycle of an order from creation to completion or cancellation.
 */
enum OrderState {
    /**
     * Order is open and active, can be modified
     */
    ORDER_STATE_OPEN;
    
    /**
     * Order is in draft state, not yet submitted
     */
    ORDER_STATE_DRAFT;
    
    /**
     * Order has been canceled
     */
    ORDER_STATE_CANCELED;
    
    /**
     * Order is closed/completed
     */
    ORDER_STATE_CLOSED;
}