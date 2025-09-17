package spoton.models.labor;

/**
 * Employee model representing a labor employee in the SpotOn system
 * Used for labor management functionality (EXPRESS ONLY)
 */
typedef Employee = {
    /**
     * Unique identifier for the employee (UUID format)
     */
    var id: String;
    
    /**
     * Employee's first name
     */
    var first_name: String;
    
    /**
     * Employee's last name
     */
    var last_name: String;
    
    /**
     * Employee's email address
     */
    var email: String;
    
    /**
     * Current status of the employee
     */
    var status: String;
}