package spoton.models.loyalty;

/**
 * Customer typedef for SpotOn loyalty system
 * Represents a customer with basic information and loyalty points
 */
typedef Customer = {
    /**
     * Unique customer identifier
     */
    var id: String;
    
    /**
     * Customer email address
     */
    var email: String;
    
    /**
     * Customer phone number
     */
    var phone: String;
    
    /**
     * Customer full name
     */
    var full_name: String;
    
    /**
     * Available loyalty points for the customer
     */
    var points_available: Int;
}