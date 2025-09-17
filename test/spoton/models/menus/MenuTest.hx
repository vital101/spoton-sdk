package test.spoton.models.menus;

import utest.Test;
import utest.Assert;
import spoton.models.menus.Menu;

/**
 * Test suite for Menu model
 * Tests model structure, property access, and menu management scenarios
 */
class MenuTest extends Test {
    
    function testMenuCreation() {
        var menu: Menu = {
            id: "menu_123456789",
            location_id: "loc_987654321",
            name: "Lunch Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 10, 30, 0)
        };
        
        Assert.equals("menu_123456789", menu.id);
        Assert.equals("loc_987654321", menu.location_id);
        Assert.equals("Lunch Menu", menu.name);
        Assert.isTrue(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuInactive() {
        var menu: Menu = {
            id: "menu_inactive",
            location_id: "loc_test",
            name: "Discontinued Menu",
            active: false,
            created_at: new Date(2023, 11, 31, 23, 59, 59)
        };
        
        Assert.equals("menu_inactive", menu.id);
        Assert.equals("loc_test", menu.location_id);
        Assert.equals("Discontinued Menu", menu.name);
        Assert.isFalse(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuPropertyModification() {
        var menu: Menu = {
            id: "menu_original",
            location_id: "loc_original",
            name: "Original Menu",
            active: false,
            created_at: new Date(2024, 0, 1, 0, 0, 0)
        };
        
        // Modify properties
        menu.id = "menu_updated";
        menu.location_id = "loc_updated";
        menu.name = "Updated Menu Name";
        menu.active = true;
        menu.created_at = new Date(2024, 0, 31, 23, 59, 59);
        
        Assert.equals("menu_updated", menu.id);
        Assert.equals("loc_updated", menu.location_id);
        Assert.equals("Updated Menu Name", menu.name);
        Assert.isTrue(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuWithEmptyValues() {
        var menu: Menu = {
            id: "",
            location_id: "",
            name: "",
            active: false,
            created_at: new Date(1970, 0, 1, 0, 0, 0)
        };
        
        Assert.equals("", menu.id);
        Assert.equals("", menu.location_id);
        Assert.equals("", menu.name);
        Assert.isFalse(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuActiveToggle() {
        var menu: Menu = {
            id: "menu_toggle_test",
            location_id: "loc_test",
            name: "Toggle Test Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 12, 0, 0)
        };
        
        // Test active toggle
        Assert.isTrue(menu.active);
        
        menu.active = false;
        Assert.isFalse(menu.active);
        
        menu.active = true;
        Assert.isTrue(menu.active);
    }
    
    function testMenuWithSpecialCharacters() {
        var menu: Menu = {
            id: "menu_special_chars",
            location_id: "loc_international",
            name: "Café & Bistro Menu - \"Special\" Items!",
            active: true,
            created_at: new Date(2024, 0, 15, 14, 30, 0)
        };
        
        Assert.equals("menu_special_chars", menu.id);
        Assert.equals("loc_international", menu.location_id);
        Assert.equals("Café & Bistro Menu - \"Special\" Items!", menu.name);
        Assert.isTrue(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuNameVariations() {
        var menu: Menu = {
            id: "menu_name_test",
            location_id: "loc_test",
            name: "Breakfast Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 8, 0, 0)
        };
        
        // Test different menu name types
        menu.name = "Breakfast Menu";
        Assert.equals("Breakfast Menu", menu.name);
        
        menu.name = "Lunch & Dinner";
        Assert.equals("Lunch & Dinner", menu.name);
        
        menu.name = "Happy Hour Specials";
        Assert.equals("Happy Hour Specials", menu.name);
        
        menu.name = "Kids Menu";
        Assert.equals("Kids Menu", menu.name);
        
        menu.name = "Seasonal Menu - Spring 2024";
        Assert.equals("Seasonal Menu - Spring 2024", menu.name);
    }
    
    function testMenuDateHandling() {
        // Test different creation date scenarios
        var morningMenu: Menu = {
            id: "menu_morning",
            location_id: "loc_test",
            name: "Morning Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 6, 0, 0)
        };
        
        var eveningMenu: Menu = {
            id: "menu_evening",
            location_id: "loc_test",
            name: "Evening Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 18, 0, 0)
        };
        
        var lateNightMenu: Menu = {
            id: "menu_late_night",
            location_id: "loc_test",
            name: "Late Night Menu",
            active: false,
            created_at: new Date(2024, 0, 15, 23, 30, 0)
        };
        
        Assert.notNull(morningMenu.created_at);
        Assert.notNull(eveningMenu.created_at);
        Assert.notNull(lateNightMenu.created_at);
        
        // Test that dates are different
        Assert.notEquals(morningMenu.created_at.getTime(), eveningMenu.created_at.getTime());
        Assert.notEquals(eveningMenu.created_at.getTime(), lateNightMenu.created_at.getTime());
    }
    
    function testMenuUUIDFormat() {
        var menu: Menu = {
            id: "550e8400-e29b-41d4-a716-446655440000",
            location_id: "660f9500-f39c-52e5-b827-557766551111",
            name: "UUID Format Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 12, 0, 0)
        };
        
        Assert.equals("550e8400-e29b-41d4-a716-446655440000", menu.id);
        Assert.equals("660f9500-f39c-52e5-b827-557766551111", menu.location_id);
        Assert.equals("UUID Format Menu", menu.name);
        Assert.isTrue(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuLongName() {
        var longName = "This is a very long menu name that exceeds normal length expectations " +
                      "and includes multiple words to test how the model handles extended text content " +
                      "for menu names in the restaurant management system";
        
        var menu: Menu = {
            id: "menu_long_name",
            location_id: "loc_test",
            name: longName,
            active: true,
            created_at: new Date(2024, 0, 15, 10, 0, 0)
        };
        
        Assert.equals("menu_long_name", menu.id);
        Assert.equals("loc_test", menu.location_id);
        Assert.equals(longName, menu.name);
        Assert.isTrue(menu.active);
        Assert.notNull(menu.created_at);
    }
    
    function testMenuDateComparison() {
        var oldMenu: Menu = {
            id: "menu_old",
            location_id: "loc_test",
            name: "Old Menu",
            active: false,
            created_at: new Date(2023, 0, 1, 0, 0, 0)
        };
        
        var newMenu: Menu = {
            id: "menu_new",
            location_id: "loc_test",
            name: "New Menu",
            active: true,
            created_at: new Date(2024, 0, 15, 12, 0, 0)
        };
        
        // Test that new menu was created after old menu
        Assert.isTrue(newMenu.created_at.getTime() > oldMenu.created_at.getTime());
        
        // Test date modification
        oldMenu.created_at = new Date(2024, 0, 20, 0, 0, 0);
        Assert.isTrue(oldMenu.created_at.getTime() > newMenu.created_at.getTime());
    }
}