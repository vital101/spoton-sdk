package spoton.models.orders;

/**
 * OrderCustomer typedef representing customer information for orders
 * Used in order processing and customer identification
 */
typedef OrderCustomer = {
    /**
     * Customer ID - unique identifier for the customer
     */
    var id: String;
    
    /**
     * External reference ID - identifier from external system
     */
    var external_reference_id: String;
    
    /**
     * Customer's first name
     */
    var first_name: String;
    
    /**
     * Customer's last name
     */
    var last_name: String;
    
    /**
     * Customer's email address
     */
    var email: String;
    
    /**
     * Customer's phone number
     */
    var phone: String;
}