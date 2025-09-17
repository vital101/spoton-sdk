package spoton.models.loyalty;

/**
 * Represents the loyalty status and configuration for a specific location
 */
typedef LocationStatus = {
    /**
     * The location ID this status applies to
     */
    var location_id: String;
    
    /**
     * Whether loyalty is enabled for this location
     */
    var loyalty_enabled: Bool;
    
    /**
     * Whether the location is actively accepting loyalty transactions
     */
    var active: Bool;
    
    /**
     * Configuration details for the loyalty program at this location
     */
    var ?configuration: Dynamic;
    
    /**
     * Last updated timestamp for the loyalty status
     */
    var ?updated_at: String;
}