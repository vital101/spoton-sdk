package test.spoton.models.menus;

import utest.Test;
import utest.Assert;
import spoton.models.menus.MenuItem;

/**
 * Test suite for MenuItem model
 * Tests model structure, property access, and availability scenarios
 */
class MenuItemTest extends Test {
    
    function testMenuItemCreation() {
        var menuItem: MenuItem = {
            id: "item_123",
            location_id: "loc_456",
            menu_id: "menu_789",
            name: "Cheeseburger",
            description: "Juicy beef patty with cheese, lettuce, and tomato",
            active: true,
            is_available: true
        };
        
        Assert.equals("item_123", menuItem.id);
        Assert.equals("loc_456", menuItem.location_id);
        Assert.equals("menu_789", menuItem.menu_id);
        Assert.equals("Cheeseburger", menuItem.name);
        Assert.equals("Juicy beef patty with cheese, lettuce, and tomato", menuItem.description);
        Assert.isTrue(menuItem.active);
        Assert.isTrue(menuItem.is_available);
    }
    
    function testMenuItemInactive() {
        var menuItem: MenuItem = {
            id: "item_inactive",
            location_id: "loc_test",
            menu_id: "menu_test",
            name: "Discontinued Item",
            description: "This item is no longer available",
            active: false,
            is_available: false
        };
        
        Assert.equals("item_inactive", menuItem.id);
        Assert.equals("Discontinued Item", menuItem.name);
        Assert.isFalse(menuItem.active);
        Assert.isFalse(menuItem.is_available);
    }
    
    function testMenuItemActiveButUnavailable() {
        var menuItem: MenuItem = {
            id: "item_temp_unavailable",
            location_id: "loc_test",
            menu_id: "menu_test",
            name: "Seasonal Special",
            description: "Available only during certain seasons",
            active: true,
            is_available: false
        };
        
        Assert.equals("item_temp_unavailable", menuItem.id);
        Assert.equals("Seasonal Special", menuItem.name);
        Assert.isTrue(menuItem.active);
        Assert.isFalse(menuItem.is_available);
    }
    
    function testMenuItemPropertyModification() {
        var menuItem: MenuItem = {
            id: "item_modify",
            location_id: "loc_test",
            menu_id: "menu_test",
            name: "Original Name",
            description: "Original description",
            active: true,
            is_available: true
        };
        
        // Modify properties
        menuItem.name = "Updated Name";
        menuItem.description = "Updated description with more details";
        menuItem.active = false;
        menuItem.is_available = false;
        
        Assert.equals("Updated Name", menuItem.name);
        Assert.equals("Updated description with more details", menuItem.description);
        Assert.isFalse(menuItem.active);
        Assert.isFalse(menuItem.is_available);
    }
    
    function testMenuItemWithEmptyDescription() {
        var menuItem: MenuItem = {
            id: "item_no_desc",
            location_id: "loc_test",
            menu_id: "menu_test",
            name: "Simple Item",
            description: "",
            active: true,
            is_available: true
        };
        
        Assert.equals("item_no_desc", menuItem.id);
        Assert.equals("Simple Item", menuItem.name);
        Assert.equals("", menuItem.description);
        Assert.isTrue(menuItem.active);
        Assert.isTrue(menuItem.is_available);
    }
    
    function testMenuItemWithSpecialCharacters() {
        var menuItem: MenuItem = {
            id: "item_special_chars",
            location_id: "loc_international",
            menu_id: "menu_international",
            name: "Café au Lait & Croissant",
            description: "Traditional French café au lait with a buttery croissant - très délicieux!",
            active: true,
            is_available: true
        };
        
        Assert.equals("item_special_chars", menuItem.id);
        Assert.equals("Café au Lait & Croissant", menuItem.name);
        Assert.equals("Traditional French café au lait with a buttery croissant - très délicieux!", menuItem.description);
        Assert.isTrue(menuItem.active);
        Assert.isTrue(menuItem.is_available);
    }
    
    function testMenuItemLongDescription() {
        var longDescription = "This is a very detailed description of a menu item that includes multiple sentences. " +
                             "It describes the ingredients, preparation method, and serving suggestions. " +
                             "The description is intentionally long to test how the model handles extended text content. " +
                             "It may include special dietary information, allergen warnings, and other important details.";
        
        var menuItem: MenuItem = {
            id: "item_long_desc",
            location_id: "loc_test",
            menu_id: "menu_test",
            name: "Detailed Item",
            description: longDescription,
            active: true,
            is_available: true
        };
        
        Assert.equals("item_long_desc", menuItem.id);
        Assert.equals("Detailed Item", menuItem.name);
        Assert.equals(longDescription, menuItem.description);
        Assert.isTrue(menuItem.active);
        Assert.isTrue(menuItem.is_available);
    }
    
    function testMenuItemAvailabilityStates() {
        var menuItem: MenuItem = {
            id: "item_availability_test",
            location_id: "loc_test",
            menu_id: "menu_test",
            name: "Availability Test Item",
            description: "Testing availability states",
            active: true,
            is_available: true
        };
        
        // Test all combinations of active/available states
        
        // Active and available
        Assert.isTrue(menuItem.active);
        Assert.isTrue(menuItem.is_available);
        
        // Active but not available
        menuItem.is_available = false;
        Assert.isTrue(menuItem.active);
        Assert.isFalse(menuItem.is_available);
        
        // Not active but available (unusual case)
        menuItem.active = false;
        menuItem.is_available = true;
        Assert.isFalse(menuItem.active);
        Assert.isTrue(menuItem.is_available);
        
        // Not active and not available
        menuItem.is_available = false;
        Assert.isFalse(menuItem.active);
        Assert.isFalse(menuItem.is_available);
    }
}