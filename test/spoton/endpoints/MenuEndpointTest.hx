package test.spoton.endpoints;

import utest.Test;
import utest.Assert;
import spoton.endpoints.MenuEndpoint;
import spoton.models.menus.Menu;
import spoton.models.menus.MenuItem;
import spoton.errors.SpotOnException;
import spoton.errors.APIException;
import test.spoton.http.MockHTTPClient;
import test.spoton.auth.MockAuthenticationManager;

/**
 * Test class for MenuEndpoint functionality
 * Tests menu-related operations including menu retrieval and menu item management
 */
class MenuEndpointTest extends Test {
    
    private var mockHttpClient: MockHTTPClient;
    private var mockAuth: MockAuthenticationManager;
    private var menuEndpoint: MenuEndpoint;
    
    public function setup() {
        mockHttpClient = new MockHTTPClient();
        mockAuth = new MockAuthenticationManager();
        mockAuth.setAuthenticationState(true);
        menuEndpoint = new MenuEndpoint(mockHttpClient, mockAuth);
    }
    
    public function teardown() {
        mockHttpClient = null;
        mockAuth = null;
        menuEndpoint = null;
    }
    
    // Test getMenus functionality
    
    public function testGetMenusSuccess() {
        var locationId = "BL-1234-5678-9012";
        
        var expectedMenus = [
            {
                id: "menu-1",
                location_id: locationId,
                name: "Breakfast Menu",
                active: true,
                created_at: "2023-01-01 08:00:00"
            },
            {
                id: "menu-2",
                location_id: locationId,
                name: "Lunch Menu",
                active: true,
                created_at: "2023-01-01 11:00:00"
            }
        ];
        
        // Configure mock response for successful menu retrieval
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(expectedMenus),
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseMenus: Array<Menu> = null;
        
        menuEndpoint.getMenus(locationId, function(menus: Array<Menu>) {
            callbackCalled = true;
            responseMenus = menus;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseMenus);
        Assert.equals(2, responseMenus.length);
        
        // Verify first menu
        Assert.equals("menu-1", responseMenus[0].id);
        Assert.equals(locationId, responseMenus[0].location_id);
        Assert.equals("Breakfast Menu", responseMenus[0].name);
        Assert.equals(true, responseMenus[0].active);
        
        // Verify second menu
        Assert.equals("menu-2", responseMenus[1].id);
        Assert.equals("Lunch Menu", responseMenus[1].name);
        
        // Verify correct HTTP request was made
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("GET", request.method);
        Assert.equals('/menu/v1/locations/${locationId}/menus', request.path);
        Assert.isNull(request.data);
    }
    
    public function testGetMenusWithWrappedResponse() {
        var locationId = "BL-1234-5678-9012";
        
        var wrappedResponse = {
            data: [
                {
                    id: "menu-1",
                    location_id: locationId,
                    name: "Test Menu",
                    active: true,
                    created_at: "2023-01-01 08:00:00"
                }
            ]
        };
        
        // Configure mock response with wrapped data
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(wrappedResponse),
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseMenus: Array<Menu> = null;
        
        menuEndpoint.getMenus(locationId, function(menus: Array<Menu>) {
            callbackCalled = true;
            responseMenus = menus;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseMenus);
        Assert.equals(1, responseMenus.length);
        Assert.equals("menu-1", responseMenus[0].id);
        Assert.equals("Test Menu", responseMenus[0].name);
    }
    
    public function testGetMenusEmptyResponse() {
        var locationId = "BL-1234-5678-9012";
        
        // Configure mock response for empty menu list
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '[]',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseMenus: Array<Menu> = null;
        
        menuEndpoint.getMenus(locationId, function(menus: Array<Menu>) {
            callbackCalled = true;
            responseMenus = menus;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseMenus);
        Assert.equals(0, responseMenus.length);
    }
    
    // Test getMenu functionality
    
    public function testGetMenuSuccess() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        var expectedMenu = {
            id: menuId,
            location_id: locationId,
            name: "Dinner Menu",
            active: true,
            created_at: "2023-01-01 17:00:00"
        };
        
        // Configure mock response for successful single menu retrieval
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(expectedMenu),
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseMenu: Menu = null;
        
        menuEndpoint.getMenu(locationId, menuId, function(menu: Menu) {
            callbackCalled = true;
            responseMenu = menu;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseMenu);
        Assert.equals(menuId, responseMenu.id);
        Assert.equals(locationId, responseMenu.location_id);
        Assert.equals("Dinner Menu", responseMenu.name);
        Assert.equals(true, responseMenu.active);
        
        // Verify correct HTTP request was made
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("GET", request.method);
        Assert.equals('/menu/v1/locations/${locationId}/menus/${menuId}', request.path);
        Assert.isNull(request.data);
    }
    
    public function testGetMenuNotFound() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-999";
        
        // Configure mock response for menu not found
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}', {
            statusCode: 404,
            headers: new Map<String, String>(),
            body: '{"error": "Menu not found"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenu(locationId, menuId, function(menu: Menu) {
                Assert.fail("Callback should not be called when menu not found");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("NOT_FOUND", e.errorCode);
            Assert.equals(404, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    // Test getMenuItems functionality
    
    public function testGetMenuItemsSuccess() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        var expectedItems = [
            {
                id: "item-1",
                location_id: locationId,
                menu_id: menuId,
                name: "Burger",
                description: "Delicious beef burger",
                active: true,
                is_available: true
            },
            {
                id: "item-2",
                location_id: locationId,
                menu_id: menuId,
                name: "Fries",
                description: "Crispy french fries",
                active: true,
                is_available: false
            }
        ];
        
        // Configure mock response for successful menu items retrieval
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}/items', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(expectedItems),
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseItems: Array<MenuItem> = null;
        
        menuEndpoint.getMenuItems(locationId, menuId, function(items: Array<MenuItem>) {
            callbackCalled = true;
            responseItems = items;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseItems);
        Assert.equals(2, responseItems.length);
        
        // Verify first item
        Assert.equals("item-1", responseItems[0].id);
        Assert.equals(locationId, responseItems[0].location_id);
        Assert.equals(menuId, responseItems[0].menu_id);
        Assert.equals("Burger", responseItems[0].name);
        Assert.equals("Delicious beef burger", responseItems[0].description);
        Assert.equals(true, responseItems[0].active);
        Assert.equals(true, responseItems[0].is_available);
        
        // Verify second item
        Assert.equals("item-2", responseItems[1].id);
        Assert.equals("Fries", responseItems[1].name);
        Assert.equals(false, responseItems[1].is_available);
        
        // Verify correct HTTP request was made
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("GET", request.method);
        Assert.equals('/menu/v1/locations/${locationId}/menus/${menuId}/items', request.path);
        Assert.isNull(request.data);
    }
    
    public function testGetMenuItemsWithWrappedResponse() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        var wrappedResponse = {
            items: [
                {
                    id: "item-1",
                    location_id: locationId,
                    menu_id: menuId,
                    name: "Test Item",
                    description: "Test description",
                    active: true,
                    is_available: true
                }
            ]
        };
        
        // Configure mock response with wrapped items
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}/items', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(wrappedResponse),
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseItems: Array<MenuItem> = null;
        
        menuEndpoint.getMenuItems(locationId, menuId, function(items: Array<MenuItem>) {
            callbackCalled = true;
            responseItems = items;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseItems);
        Assert.equals(1, responseItems.length);
        Assert.equals("item-1", responseItems[0].id);
        Assert.equals("Test Item", responseItems[0].name);
    }    
    
// Test parameter validation
    
    public function testGetMenusWithNullLocationId() {
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenus(null, function(menus: Array<Menu>) {
                Assert.fail("Callback should not be called with null location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenusWithEmptyLocationId() {
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenus("", function(menus: Array<Menu>) {
                Assert.fail("Callback should not be called with empty location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuWithNullLocationId() {
        var menuId = "menu-123";
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenu(null, menuId, function(menu: Menu) {
                Assert.fail("Callback should not be called with null location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuWithNullMenuId() {
        var locationId = "BL-1234-5678-9012";
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenu(locationId, null, function(menu: Menu) {
                Assert.fail("Callback should not be called with null menu ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_MENU_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Menu ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuItemsWithNullLocationId() {
        var menuId = "menu-123";
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenuItems(null, menuId, function(items: Array<MenuItem>) {
                Assert.fail("Callback should not be called with null location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuItemsWithNullMenuId() {
        var locationId = "BL-1234-5678-9012";
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenuItems(locationId, null, function(items: Array<MenuItem>) {
                Assert.fail("Callback should not be called with null menu ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_MENU_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Menu ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    // Test authentication integration
    
    public function testGetMenusIncludesAuthHeaders() {
        var locationId = "BL-1234-5678-9012";
        
        // Configure mock auth with specific headers
        mockAuth.setMockToken("test_menu_token");
        mockAuth.setMockApiKey("test_menu_api_key");
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '[]',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        menuEndpoint.getMenus(locationId, function(menus: Array<Menu>) {
            callbackCalled = true;
        });
        
        Assert.isTrue(callbackCalled);
        
        // Verify auth headers were included in request
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.isTrue(request.headers.exists("Authorization"));
        Assert.equals("Bearer test_menu_token", request.headers.get("Authorization"));
        Assert.isTrue(request.headers.exists("X-API-Key"));
        Assert.equals("test_menu_api_key", request.headers.get("X-API-Key"));
        
        // Verify auth headers were requested
        Assert.equals(1, mockAuth.getAuthHeadersCalls);
    }
    
    public function testGetMenuIncludesAuthHeaders() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        // Configure mock auth with specific headers
        mockAuth.setMockToken("test_single_menu_token");
        mockAuth.setMockApiKey("test_single_menu_api_key");
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"id": "menu-123", "name": "Test Menu", "active": true}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        menuEndpoint.getMenu(locationId, menuId, function(menu: Menu) {
            callbackCalled = true;
        });
        
        Assert.isTrue(callbackCalled);
        
        // Verify auth headers were included in request
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.isTrue(request.headers.exists("Authorization"));
        Assert.equals("Bearer test_single_menu_token", request.headers.get("Authorization"));
        Assert.isTrue(request.headers.exists("X-API-Key"));
        Assert.equals("test_single_menu_api_key", request.headers.get("X-API-Key"));
        
        // Verify auth headers were requested
        Assert.equals(1, mockAuth.getAuthHeadersCalls);
    }
    
    public function testGetMenuItemsIncludesAuthHeaders() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        // Configure mock auth with specific headers
        mockAuth.setMockToken("test_items_token");
        mockAuth.setMockApiKey("test_items_api_key");
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}/items', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '[]',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        menuEndpoint.getMenuItems(locationId, menuId, function(items: Array<MenuItem>) {
            callbackCalled = true;
        });
        
        Assert.isTrue(callbackCalled);
        
        // Verify auth headers were included in request
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.isTrue(request.headers.exists("Authorization"));
        Assert.equals("Bearer test_items_token", request.headers.get("Authorization"));
        Assert.isTrue(request.headers.exists("X-API-Key"));
        Assert.equals("test_items_api_key", request.headers.get("X-API-Key"));
        
        // Verify auth headers were requested
        Assert.equals(1, mockAuth.getAuthHeadersCalls);
    }
    
    // Test error handling and response parsing
    
    public function testGetMenusWithInvalidJsonResponse() {
        var locationId = "BL-1234-5678-9012";
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: 'invalid json response {',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenus(locationId, function(menus: Array<Menu>) {
                Assert.fail("Callback should not be called with invalid JSON");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("JSON_PARSE_ERROR", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuWithInvalidJsonResponse() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: 'invalid json response {',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenu(locationId, menuId, function(menu: Menu) {
                Assert.fail("Callback should not be called with invalid JSON");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("JSON_PARSE_ERROR", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuItemsWithInvalidJsonResponse() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}/items', {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: 'invalid json response {',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenuItems(locationId, menuId, function(items: Array<MenuItem>) {
                Assert.fail("Callback should not be called with invalid JSON");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("JSON_PARSE_ERROR", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenusWithNetworkError() {
        var locationId = "BL-1234-5678-9012";
        
        // Simulate network error
        mockHttpClient.simulateNetworkError = true;
        mockHttpClient.networkErrorMessage = "Connection timeout";
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenus(locationId, function(menus: Array<Menu>) {
                Assert.fail("Callback should not be called on network error");
            });
        } catch (e: Dynamic) {
            exceptionThrown = true;
            var errorMessage = Std.string(e);
            Assert.isTrue(errorMessage.indexOf("Network") >= 0 || 
                         errorMessage.indexOf("Connection") >= 0 ||
                         errorMessage.indexOf("timeout") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetMenuItemsWithAuthenticationFailure() {
        var locationId = "BL-1234-5678-9012";
        var menuId = "menu-123";
        
        // Configure mock auth to fail
        mockAuth.setAuthenticationState(false);
        
        mockHttpClient.setMockResponse("GET", '/menu/v1/locations/${locationId}/menus/${menuId}/items', {
            statusCode: 401,
            headers: new Map<String, String>(),
            body: '{"error": "Unauthorized"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            menuEndpoint.getMenuItems(locationId, menuId, function(items: Array<MenuItem>) {
                Assert.fail("Callback should not be called on auth failure");
            });
        } catch (e: Dynamic) {
            exceptionThrown = true;
            // Should throw authentication-related exception
            Assert.isTrue(Std.string(e).indexOf("Unauthorized") >= 0 || 
                         Std.string(e).indexOf("UNAUTHORIZED") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
}