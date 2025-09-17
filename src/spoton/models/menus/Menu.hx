package spoton.models.menus;

/**
 * Menu typedef representing a restaurant menu
 * Based on SpotOn Central API Menu schema
 */
typedef Menu = {
    /**
     * Unique identifier for the menu
     */
    var id: String;
    
    /**
     * Location ID this menu belongs to
     */
    var location_id: String;
    
    /**
     * Display name of the menu
     */
    var name: String;
    
    /**
     * Whether the menu is currently active
     */
    var active: Bool;
    
    /**
     * Timestamp when the menu was created
     */
    var created_at: Date;
}