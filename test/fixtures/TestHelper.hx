package test.fixtures;

import test.spoton.http.MockHTTPClient;
import test.spoton.auth.MockAuthenticationManager;
import spoton.auth.Credentials;

/**
 * Test helper utility that combines builders, fixtures, and common test setup
 * Provides convenience methods for setting up test scenarios
 */
class TestHelper {
    
    /**
     * Create a configured MockHTTPClient with common responses
     */
    public static function createMockHttpClient(): MockHTTPClient {
        var mockClient = new MockHTTPClient();
        
        // Set up common successful responses
        mockClient.setMockResponse("GET", "/business/v1/livez", 
            FixtureLoader.createMockResponse("api_responses/business/liveness_success.json"));
        
        mockClient.setMockResponse("GET", "/business/v1/locations/BL-1234-5678-9012-3456", 
            FixtureLoader.createMockResponse("api_responses/business/location_success.json"));
        
        mockClient.setMockResponse("GET", "/orders/v1/orders/ORD-2023-001234", 
            FixtureLoader.createMockResponse("api_responses/orders/order_success.json"));
        
        mockClient.setMockResponse("GET", "/menus/v1/menus/MENU-LUNCH-001", 
            FixtureLoader.createMockResponse("api_responses/menus/menu_success.json"));
        
        // Set up common error responses
        mockClient.setMockResponse("GET", "/business/v1/locations/BL-9999-9999-9999-9999", 
            FixtureLoader.createErrorResponse("not_found"));
        
        return mockClient;
    }
    
    /**
     * Create a configured MockAuthenticationManager
     */
    public static function createMockAuthManager(authenticated: Bool = true): MockAuthenticationManager {
        var mockAuth = new MockAuthenticationManager();
        mockAuth.setAuthenticationState(authenticated);
        
        if (authenticated) {
            mockAuth.setMockToken(TestData.VALID_BEARER_TOKEN);
            mockAuth.setMockApiKey("sk_test_1234567890abcdef1234567890abcdef12345678");
        }
        
        return mockAuth;
    }
    
    /**
     * Set up a mock HTTP client for successful business endpoint tests
     */
    public static function setupBusinessEndpointMocks(mockClient: MockHTTPClient): Void {
        // Liveness endpoint
        mockClient.setMockResponse("GET", "/business/v1/livez", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/business/liveness_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
        
        // Location endpoints
        mockClient.setMockResponse("GET", "/business/v1/locations/BL-1234-5678-9012-3456", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/business/location_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
        
        mockClient.setMockResponse("GET", "/business/v1/locations", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/business/location_list_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
    }
    
    /**
     * Set up a mock HTTP client for successful order endpoint tests
     */
    public static function setupOrderEndpointMocks(mockClient: MockHTTPClient): Void {
        // Single order endpoint
        mockClient.setMockResponse("GET", "/orders/v1/orders/ORD-2023-001234", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/orders/order_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
        
        // Order list endpoint
        mockClient.setMockResponse("GET", "/orders/v1/orders", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/orders/order_list_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
        
        // Order creation endpoint
        mockClient.setMockResponse("POST", "/orders/v1/orders", {
            statusCode: 201,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/orders/order_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
    }
    
    /**
     * Set up a mock HTTP client for successful menu endpoint tests
     */
    public static function setupMenuEndpointMocks(mockClient: MockHTTPClient): Void {
        // Single menu endpoint
        mockClient.setMockResponse("GET", "/menus/v1/menus/MENU-LUNCH-001", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/menus/menu_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
        
        // Menu list endpoint
        mockClient.setMockResponse("GET", "/menus/v1/menus", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: FixtureLoader.loadJsonString("api_responses/menus/menu_list_success.json"),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
    }
    
    /**
     * Set up common error response mocks
     */
    public static function setupErrorResponseMocks(mockClient: MockHTTPClient): Void {
        // 404 Not Found
        mockClient.setMockResponse("GET", "/business/v1/locations/BL-9999-9999-9999-9999", 
            FixtureLoader.createErrorResponse("not_found"));
        
        mockClient.setMockResponse("GET", "/orders/v1/orders/ORD-9999-999999", 
            FixtureLoader.createErrorResponse("not_found"));
        
        // 401 Unauthorized
        mockClient.setMockResponse("GET", "/unauthorized-endpoint", 
            FixtureLoader.createErrorResponse("unauthorized"));
        
        // 400 Bad Request
        mockClient.setMockResponse("GET", "/bad-request-endpoint", 
            FixtureLoader.createErrorResponse("bad_request"));
        
        // 500 Server Error
        mockClient.setMockResponse("GET", "/server-error-endpoint", 
            FixtureLoader.createErrorResponse("server_error"));
        
        // 429 Rate Limit
        mockClient.setMockResponse("GET", "/rate-limit-endpoint", 
            FixtureLoader.createErrorResponse("rate_limit"));
    }
    
    /**
     * Create test credentials for different scenarios
     */
    public static function createTestCredentials(type: String): Credentials {
        return switch (type) {
            case "valid_api_key": TestData.VALID_API_KEY_CREDENTIALS;
            case "valid_oauth": TestData.VALID_OAUTH_CREDENTIALS;
            case "invalid_short": TestData.INVALID_SHORT_API_KEY_CREDENTIALS;
            case "invalid_empty": TestData.INVALID_EMPTY_API_KEY_CREDENTIALS;
            case "invalid_null": TestData.INVALID_NULL_API_KEY_CREDENTIALS;
            default: TestData.VALID_API_KEY_CREDENTIALS;
        };
    }
    
    /**
     * Create a test configuration for different environments
     */
    public static function createTestConfig(environment: String): Dynamic {
        return TestData.getTestConfig(environment);
    }
    
    /**
     * Verify that a mock HTTP client received the expected request
     */
    public static function verifyHttpRequest(mockClient: MockHTTPClient, method: String, path: String): Bool {
        var requests = mockClient.getRequestsFor(method, path);
        return requests.length > 0;
    }
    
    /**
     * Verify that authentication headers were included in the last request
     */
    public static function verifyAuthHeaders(mockClient: MockHTTPClient): Bool {
        var lastRequest = mockClient.getLastRequest();
        if (lastRequest == null || lastRequest.headers == null) {
            return false;
        }
        
        return lastRequest.headers.exists("Authorization") || lastRequest.headers.exists("X-API-Key");
    }
    
    /**
     * Create a delay for testing async operations (in milliseconds)
     */
    public static function delay(ms: Int): Void {
        // In a real implementation, this would use a timer
        // For testing purposes, this is a no-op
    }
    
    /**
     * Assert that two objects have the same field values
     */
    public static function assertObjectsEqual(expected: Dynamic, actual: Dynamic, message: String = ""): Bool {
        var expectedFields = Reflect.fields(expected);
        var actualFields = Reflect.fields(actual);
        
        if (expectedFields.length != actualFields.length) {
            return false;
        }
        
        for (field in expectedFields) {
            var expectedValue = Reflect.field(expected, field);
            var actualValue = Reflect.field(actual, field);
            
            if (expectedValue != actualValue) {
                return false;
            }
        }
        
        return true;
    }
}