package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.models.menus.Menu;
import spoton.models.menus.MenuItem;
import spoton.errors.SpotOnException;

/**
 * MenuEndpoint provides access to SpotOn's Menu API endpoints.
 * This includes menu management, menu items, categories, and modifiers.
 */
class MenuEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new MenuEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Retrieves all menus for a specific location
     * @param locationId The location ID to get menus for
     * @param callback Callback function that receives an array of Menu objects
     * @throws SpotOnException if the request fails or parameters are invalid
     */
    public function getMenus(locationId: String, callback: Array<Menu> -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new SpotOnException("Location ID is required", "INVALID_LOCATION_ID");
        }
        
        // Construct the API path
        var path = '/menu/v1/locations/${locationId}/menus';
        
        // Make the GET request
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            try {
                // Parse the response into an array of Menu objects
                var menus: Array<Menu> = [];
                
                if (response != null) {
                    // Handle both array response and object with data property
                    var menuData: Array<Dynamic> = null;
                    
                    if (Std.isOfType(response, Array)) {
                        menuData = cast response;
                    } else if (response.data != null && Std.isOfType(response.data, Array)) {
                        menuData = cast response.data;
                    } else if (response.menus != null && Std.isOfType(response.menus, Array)) {
                        menuData = cast response.menus;
                    }
                    
                    if (menuData != null) {
                        for (menuItem in menuData) {
                            if (menuItem != null) {
                                var menu: Menu = {
                                    id: menuItem.id,
                                    location_id: menuItem.location_id,
                                    name: menuItem.name,
                                    active: menuItem.active == true,
                                    created_at: menuItem.created_at != null ? Date.fromString(menuItem.created_at) : null
                                };
                                menus.push(menu);
                            }
                        }
                    }
                }
                
                // Call the callback with the parsed menus
                callback(menus);
                
            } catch (e: Dynamic) {
                throw new SpotOnException("Failed to parse menus response: " + Std.string(e), "MENU_PARSE_ERROR", e);
            }
        });
    }
    
    /**
     * Retrieves a specific menu by ID for a location
     * @param locationId The location ID that owns the menu
     * @param menuId The menu ID to retrieve
     * @param callback Callback function that receives the Menu object
     * @throws SpotOnException if the request fails or parameters are invalid
     */
    public function getMenu(locationId: String, menuId: String, callback: Menu -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new SpotOnException("Location ID is required", "INVALID_LOCATION_ID");
        }
        
        if (menuId == null || menuId.length == 0) {
            throw new SpotOnException("Menu ID is required", "INVALID_MENU_ID");
        }
        
        // Construct the API path
        var path = '/menu/v1/locations/${locationId}/menus/${menuId}';
        
        // Make the GET request
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            try {
                // Parse the response into a Menu object
                var menu: Menu = null;
                
                if (response != null) {
                    // Handle both direct menu object and wrapped response
                    var menuData: Dynamic = response;
                    
                    if (response.data != null) {
                        menuData = response.data;
                    } else if (response.menu != null) {
                        menuData = response.menu;
                    }
                    
                    if (menuData != null) {
                        menu = {
                            id: menuData.id,
                            location_id: menuData.location_id,
                            name: menuData.name,
                            active: menuData.active == true,
                            created_at: menuData.created_at != null ? Date.fromString(menuData.created_at) : null
                        };
                    }
                }
                
                // Call the callback with the parsed menu
                callback(menu);
                
            } catch (e: Dynamic) {
                throw new SpotOnException("Failed to parse menu response: " + Std.string(e), "MENU_PARSE_ERROR", e);
            }
        });
    }
    
    /**
     * Retrieves all menu items for a specific menu
     * @param locationId The location ID that owns the menu
     * @param menuId The menu ID to get items for
     * @param callback Callback function that receives an array of MenuItem objects
     * @throws SpotOnException if the request fails or parameters are invalid
     */
    public function getMenuItems(locationId: String, menuId: String, callback: Array<MenuItem> -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new SpotOnException("Location ID is required", "INVALID_LOCATION_ID");
        }
        
        if (menuId == null || menuId.length == 0) {
            throw new SpotOnException("Menu ID is required", "INVALID_MENU_ID");
        }
        
        // Construct the API path
        var path = '/menu/v1/locations/${locationId}/menus/${menuId}/items';
        
        // Make the GET request
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            try {
                // Parse the response into an array of MenuItem objects
                var menuItems: Array<MenuItem> = [];
                
                if (response != null) {
                    // Handle both array response and object with data property
                    var itemData: Array<Dynamic> = null;
                    
                    if (Std.isOfType(response, Array)) {
                        itemData = cast response;
                    } else if (response.data != null && Std.isOfType(response.data, Array)) {
                        itemData = cast response.data;
                    } else if (response.items != null && Std.isOfType(response.items, Array)) {
                        itemData = cast response.items;
                    }
                    
                    if (itemData != null) {
                        for (item in itemData) {
                            if (item != null) {
                                var menuItem: MenuItem = {
                                    id: item.id,
                                    location_id: item.location_id,
                                    menu_id: item.menu_id,
                                    name: item.name,
                                    description: item.description != null ? item.description : "",
                                    active: item.active == true,
                                    is_available: item.is_available == true
                                };
                                menuItems.push(menuItem);
                            }
                        }
                    }
                }
                
                // Call the callback with the parsed menu items
                callback(menuItems);
                
            } catch (e: Dynamic) {
                throw new SpotOnException("Failed to parse menu items response: " + Std.string(e), "MENU_ITEMS_PARSE_ERROR", e);
            }
        });
    }
}