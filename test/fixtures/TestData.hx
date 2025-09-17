package test.fixtures;

import spoton.auth.Credentials;
import spoton.models.business.Location;
import spoton.models.orders.Order;
import spoton.models.orders.OrderItem;
import spoton.models.orders.OrderState;
import spoton.models.menus.Menu;
import spoton.models.common.Address;

/**
 * Static test data objects for common test scenarios
 * Provides pre-built objects for frequently used test cases
 */
class TestData {
    
    // Authentication test data
    public static var VALID_API_KEY_CREDENTIALS: Credentials = {
        apiKey: "sk_test_1234567890abcdef1234567890abcdef12345678"
    };
    
    public static var VALID_OAUTH_CREDENTIALS: Credentials = {
        clientId: "client_test_12345678901234567890",
        clientSecret: "secret_test_abcdef1234567890abcdef1234567890"
    };
    
    public static var INVALID_SHORT_API_KEY_CREDENTIALS: Credentials = {
        apiKey: "short"
    };
    
    public static var INVALID_EMPTY_API_KEY_CREDENTIALS: Credentials = {
        apiKey: ""
    };
    
    public static var INVALID_NULL_API_KEY_CREDENTIALS: Credentials = {
        apiKey: null
    };
    
    // Token test data
    public static var VALID_BEARER_TOKEN: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IlNwb3RPbiBUZXN0IiwiaWF0IjoxNTE2MjM5MDIyfQ.test_signature_for_spoton_sdk_testing";
    
    public static var EXPIRED_TOKEN: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkV4cGlyZWQgVG9rZW4iLCJleHAiOjE1MTYyMzkwMjJ9.expired_signature";
    
    public static var MALFORMED_TOKEN: String = "invalid.token.format";
    
    // Location test data
    public static var DEFAULT_TEST_LOCATION: Location = {
        id: "BL-TEST-1234-5678-9012",
        name: "Test Restaurant",
        email: "test@restaurant.com",
        phone: "+1-555-0123",
        address: {
            address_line_1: "123 Test Street",
            city: "Test City",
            state: "CA",
            zip: "12345",
            country: "US"
        },
        geolocation: {
            latitude: 37.7749,
            longitude: -122.4194
        },
        timezone: "America/Los_Angeles"
    };
    
    public static var DOWNTOWN_BISTRO_LOCATION: Location = {
        id: "BL-1234-5678-9012-3456",
        name: "Downtown Bistro",
        email: "manager@downtownbistro.com",
        phone: "+1-555-0123",
        address: {
            address_line_1: "123 Main Street",
            city: "San Francisco",
            state: "CA",
            zip: "94102",
            country: "US"
        },
        geolocation: {
            latitude: 37.7749,
            longitude: -122.4194
        },
        timezone: "America/Los_Angeles"
    };
    
    // Menu test data
    public static var DEFAULT_TEST_MENU: Menu = {
        id: "MENU-TEST-001",
        location_id: "BL-TEST-1234-5678-9012",
        name: "Test Menu",
        active: true,
        created_at: Date.fromString("2023-01-15 08:00:00")
    };
    
    public static var LUNCH_MENU: Menu = {
        id: "MENU-LUNCH-001",
        location_id: "BL-1234-5678-9012-3456",
        name: "Lunch Menu",
        active: true,
        created_at: Date.fromString("2023-01-15 08:00:00")
    };
    
    public static var INACTIVE_MENU: Menu = {
        id: "MENU-INACTIVE-001",
        location_id: "BL-TEST-1234-5678-9012",
        name: "Inactive Menu",
        active: false,
        created_at: Date.fromString("2023-01-01 00:00:00")
    };
    
    // Order item test data
    public static var CHEESEBURGER_ITEM: OrderItem = {
        line_id: "LI-001",
        item_id: "ITEM-BURGER-001",
        name: "Classic Cheeseburger",
        quantity: 2,
        price: 1299
    };
    
    public static var FRIES_ITEM: OrderItem = {
        line_id: "LI-002",
        item_id: "ITEM-FRIES-001",
        name: "French Fries",
        quantity: 1,
        price: 599
    };
    
    public static var DRINK_ITEM: OrderItem = {
        line_id: "LI-003",
        item_id: "ITEM-DRINK-001",
        name: "Soft Drink",
        quantity: 2,
        price: 299
    };
    
    // Order test data
    public static var DEFAULT_TEST_ORDER: Order = {
        id: "ORD-TEST-001234",
        external_reference_id: "EXT-TEST-789",
        location_id: "BL-TEST-1234-5678-9012",
        line_items: [CHEESEBURGER_ITEM],
        state: ORDER_STATE_OPEN,
        source: {
            channel: "test",
            platform: "test",
            version: "1.0"
        },
        customer: {
            id: "CUST-TEST-5678",
            name: "Test Customer",
            email: "test@customer.com",
            phone: "+1-555-0199"
        },
        fulfillment: {
            type: "pickup",
            requested_time: "2023-12-01T12:00:00Z",
            estimated_time: "2023-12-01T12:15:00Z"
        },
        totals: {
            subtotal: 1299,
            tax: 117,
            tip: 200,
            total: 1616
        },
        menu_id: "MENU-TEST-001"
    };
    
    public static var MULTI_ITEM_ORDER: Order = {
        id: "ORD-2023-001234",
        external_reference_id: "EXT-REF-789",
        location_id: "BL-1234-5678-9012-3456",
        line_items: [CHEESEBURGER_ITEM, FRIES_ITEM, DRINK_ITEM],
        state: ORDER_STATE_OPEN,
        source: {
            channel: "online",
            platform: "web",
            version: "1.0"
        },
        customer: {
            id: "CUST-5678-9012",
            name: "John Doe",
            email: "john.doe@example.com",
            phone: "+1-555-0199"
        },
        fulfillment: {
            type: "pickup",
            requested_time: "2023-12-01T12:00:00Z",
            estimated_time: "2023-12-01T12:15:00Z"
        },
        totals: {
            subtotal: 3197,
            tax: 287,
            tip: 500,
            total: 3984
        },
        menu_id: "MENU-LUNCH-001"
    };
    
    public static var CLOSED_ORDER: Order = {
        id: "ORD-CLOSED-001",
        external_reference_id: "EXT-CLOSED-001",
        location_id: "BL-TEST-1234-5678-9012",
        line_items: [CHEESEBURGER_ITEM],
        state: ORDER_STATE_CLOSED,
        source: {
            channel: "test",
            platform: "test",
            version: "1.0"
        },
        customer: {
            id: "CUST-TEST-5678",
            name: "Test Customer",
            email: "test@customer.com",
            phone: "+1-555-0199"
        },
        fulfillment: {
            type: "pickup",
            requested_time: "2023-12-01T11:00:00Z",
            estimated_time: "2023-12-01T11:15:00Z"
        },
        totals: {
            subtotal: 1299,
            tax: 117,
            tip: 200,
            total: 1616
        },
        menu_id: "MENU-TEST-001"
    };
    
    // Address test data
    public static var DEFAULT_TEST_ADDRESS: Address = {
        address_line_1: "123 Test Street",
        city: "Test City",
        state: "CA",
        zip: "12345",
        country: "US"
    };
    
    public static var SAN_FRANCISCO_ADDRESS: Address = {
        address_line_1: "123 Main Street",
        city: "San Francisco",
        state: "CA",
        zip: "94102",
        country: "US"
    };
    
    public static var NEW_YORK_ADDRESS: Address = {
        address_line_1: "456 Broadway",
        city: "New York",
        state: "NY",
        zip: "10013",
        country: "US"
    };
    
    // Test configuration data
    public static var DEFAULT_TEST_CONFIG = {
        enableMocks: true,
        logLevel: "ERROR",
        timeoutMs: 5000,
        retryAttempts: 3,
        baseUrl: "https://api.spoton.com"
    };
    
    public static var DEVELOPMENT_TEST_CONFIG = {
        enableMocks: true,
        logLevel: "DEBUG",
        timeoutMs: 10000,
        retryAttempts: 1,
        baseUrl: "https://api-dev.spoton.com"
    };
    
    // Common test IDs
    public static var TEST_LOCATION_IDS = [
        "BL-TEST-1234-5678-9012",
        "BL-1234-5678-9012-3456",
        "BL-INVALID-FORMAT",
        "BL-9999-9999-9999-9999"
    ];
    
    public static var TEST_ORDER_IDS = [
        "ORD-TEST-001234",
        "ORD-2023-001234",
        "ORD-CLOSED-001",
        "ORD-INVALID-FORMAT"
    ];
    
    public static var TEST_MENU_IDS = [
        "MENU-TEST-001",
        "MENU-LUNCH-001",
        "MENU-INACTIVE-001",
        "MENU-INVALID-FORMAT"
    ];
    
    /**
     * Get a test configuration by name
     */
    public static function getTestConfig(name: String): Dynamic {
        return switch (name) {
            case "default": DEFAULT_TEST_CONFIG;
            case "development": DEVELOPMENT_TEST_CONFIG;
            default: DEFAULT_TEST_CONFIG;
        };
    }
    
    /**
     * Get a test location by ID
     */
    public static function getTestLocation(id: String): Location {
        return switch (id) {
            case "BL-TEST-1234-5678-9012": DEFAULT_TEST_LOCATION;
            case "BL-1234-5678-9012-3456": DOWNTOWN_BISTRO_LOCATION;
            default: DEFAULT_TEST_LOCATION;
        };
    }
    
    /**
     * Get a test order by ID
     */
    public static function getTestOrder(id: String): Order {
        return switch (id) {
            case "ORD-TEST-001234": DEFAULT_TEST_ORDER;
            case "ORD-2023-001234": MULTI_ITEM_ORDER;
            case "ORD-CLOSED-001": CLOSED_ORDER;
            default: DEFAULT_TEST_ORDER;
        };
    }
}