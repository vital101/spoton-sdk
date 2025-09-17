package spoton.models.orders;

/**
 * Represents an individual item within an order
 */
typedef OrderItem = {
    /**
     * Unique identifier for this line item within the order
     */
    var line_id: String;
    
    /**
     * Identifier of the menu item
     */
    var item_id: String;
    
    /**
     * Name of the item
     */
    var name: String;
    
    /**
     * Quantity of this item ordered
     */
    var quantity: Int;
    
    /**
     * Price of the item (typically in cents)
     */
    var price: Int;
}