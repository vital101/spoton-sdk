package spoton.models.menus;

/**
 * MenuItem typedef representing a menu item
 * Based on SpotOn Central API MenuItem schema
 */
typedef MenuItem = {
    /**
     * Unique identifier for the menu item
     */
    var id: String;
    
    /**
     * Location ID this menu item belongs to
     */
    var location_id: String;
    
    /**
     * Menu ID this item belongs to
     */
    var menu_id: String;
    
    /**
     * Display name of the menu item
     */
    var name: String;
    
    /**
     * Description of the menu item
     */
    var description: String;
    
    /**
     * Whether the menu item is currently active
     */
    var active: Bool;
    
    /**
     * Whether the menu item is currently available for ordering
     */
    var is_available: Bool;
}