package test.fixtures;

import utest.Test;
import utest.Assert;
import test.fixtures.TestDataBuilder;
import test.fixtures.TestData;
import test.fixtures.FixtureLoader;
import test.fixtures.TestHelper;

/**
 * Example class demonstrating how to use the test fixtures and builders
 * This serves as documentation and reference for other test classes
 */
class ExampleUsage extends Test {
    
    /**
     * Example: Using TestDataBuilder to create test objects
     */
    public function testUsingTestDataBuilder() {
        // Create a location using the builder pattern
        var location = TestDataBuilder.location()
            .withId("BL-EXAMPLE-001")
            .withName("Example Restaurant")
            .withEmail("example@restaurant.com")
            .withTimezone("America/New_York")
            .build();
        
        Assert.equals("BL-EXAMPLE-001", location.id);
        Assert.equals("Example Restaurant", location.name);
        Assert.equals("example@restaurant.com", location.email);
        Assert.equals("America/New_York", location.timezone);
        
        // Create credentials using the builder
        var credentials = TestDataBuilder.credentials()
            .validApiKey()
            .build();
        
        Assert.notNull(credentials.apiKey);
        Assert.isTrue(credentials.apiKey.length > 10);
        
        // Create an order with multiple items
        var order = TestDataBuilder.order()
            .withId("ORD-EXAMPLE-001")
            .addLineItem(TestDataBuilder.orderItem()
                .withName("Burger")
                .withPrice(1299)
                .withQuantity(2)
                .build())
            .addLineItem(TestDataBuilder.orderItem()
                .withName("Fries")
                .withPrice(599)
                .withQuantity(1)
                .build())
            .closed()
            .build();
        
        Assert.equals("ORD-EXAMPLE-001", order.id);
        Assert.equals(2, order.line_items.length);
        Assert.equals(ORDER_STATE_CLOSED, order.state);
    }
    
    /**
     * Example: Using static TestData objects
     */
    public function testUsingStaticTestData() {
        // Use pre-defined test data
        var location = TestData.DEFAULT_TEST_LOCATION;
        Assert.equals("BL-TEST-1234-5678-9012", location.id);
        Assert.equals("Test Restaurant", location.name);
        
        var credentials = TestData.VALID_API_KEY_CREDENTIALS;
        Assert.notNull(credentials.apiKey);
        
        var order = TestData.MULTI_ITEM_ORDER;
        Assert.equals(3, order.line_items.length);
        Assert.equals(ORDER_STATE_OPEN, order.state);
        
        // Use helper methods to get test data by ID
        var specificLocation = TestData.getTestLocation("BL-1234-5678-9012-3456");
        Assert.equals("Downtown Bistro", specificLocation.name);
    }
    
    /**
     * Example: Loading JSON fixtures
     */
    public function testLoadingJsonFixtures() {
        // Load a location fixture
        var locationData = FixtureLoader.loadLocationSuccess();
        Assert.equals("BL-1234-5678-9012-3456", locationData.id);
        Assert.equals("Downtown Bistro", locationData.name);
        
        // Load error fixtures
        var notFoundError = FixtureLoader.loadNotFoundError();
        Assert.equals(404, notFoundError.status);
        Assert.equals("NOT_FOUND", notFoundError.code);
        
        // Load authentication fixtures
        var validCreds = FixtureLoader.loadValidCredentials();
        Assert.notNull(validCreds.api_key_credentials.apiKey);
        
        var tokens = FixtureLoader.loadTokens();
        Assert.notNull(tokens.valid_bearer_token);
        
        // Load test configuration
        var config = FixtureLoader.getTestConfig("development");
        Assert.equals("DEBUG", config.logLevel);
        Assert.equals(10000, config.timeoutMs);
    }
    
    /**
     * Example: Creating mock responses from fixtures
     */
    public function testCreatingMockResponses() {
        // Create a successful mock response
        var successResponse = FixtureLoader.createMockResponse(
            "api_responses/business/location_success.json", 200);
        
        Assert.equals(200, successResponse.statusCode);
        Assert.notNull(successResponse.body);
        Assert.isFalse(successResponse.shouldFail);
        
        // Create an error mock response
        var errorResponse = FixtureLoader.createErrorResponse("not_found");
        Assert.equals(404, errorResponse.statusCode);
        Assert.notNull(errorResponse.body);
        
        // Verify the error response contains expected data
        var errorData = haxe.Json.parse(errorResponse.body);
        Assert.equals("Not Found", errorData.error);
        Assert.equals("NOT_FOUND", errorData.code);
    }
    
    /**
     * Example: Using TestHelper for common test setup
     */
    public function testUsingTestHelper() {
        // Create a pre-configured mock HTTP client
        var mockClient = TestHelper.createMockHttpClient();
        Assert.notNull(mockClient);
        
        // Create a mock authentication manager
        var mockAuth = TestHelper.createMockAuthManager(true);
        Assert.isTrue(mockAuth.isAuthenticatedStatus());
        
        // Set up specific endpoint mocks
        TestHelper.setupBusinessEndpointMocks(mockClient);
        TestHelper.setupOrderEndpointMocks(mockClient);
        TestHelper.setupErrorResponseMocks(mockClient);
        
        // Create test credentials
        var validCreds = TestHelper.createTestCredentials("valid_api_key");
        Assert.notNull(validCreds.apiKey);
        
        var invalidCreds = TestHelper.createTestCredentials("invalid_short");
        Assert.equals("short", invalidCreds.apiKey);
        
        // Create test configuration
        var devConfig = TestHelper.createTestConfig("development");
        Assert.equals("DEBUG", devConfig.logLevel);
    }
    
    /**
     * Example: Complete test scenario using all fixtures
     */
    public function testCompleteScenarioWithFixtures() {
        // Set up test environment
        var mockClient = TestHelper.createMockHttpClient();
        var mockAuth = TestHelper.createMockAuthManager(true);
        
        // Configure specific responses
        mockClient.setMockResponse("GET", "/business/v1/locations/BL-TEST-001", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(TestData.DEFAULT_TEST_LOCATION),
            delay: 0,
            shouldFail: false,
            errorType: null
        });
        
        // Simulate making a request
        var responseReceived = false;
        var responseData: Dynamic = null;
        
        mockClient.get("/business/v1/locations/BL-TEST-001", null, null, function(response) {
            responseReceived = true;
            responseData = response.data;
        });
        
        // Verify the response
        Assert.isTrue(responseReceived);
        Assert.notNull(responseData);
        Assert.equals("BL-TEST-1234-5678-9012", responseData.id);
        Assert.equals("Test Restaurant", responseData.name);
        
        // Verify the request was recorded
        Assert.isTrue(TestHelper.verifyHttpRequest(mockClient, "GET", "/business/v1/locations/BL-TEST-001"));
        
        // Verify request history
        var requests = mockClient.getRequestsFor("GET", "/business/v1/locations/BL-TEST-001");
        Assert.equals(1, requests.length);
        Assert.equals("GET", requests[0].method);
    }
    
    /**
     * Example: Testing error scenarios with fixtures
     */
    public function testErrorScenariosWithFixtures() {
        var mockClient = new MockHTTPClient();
        
        // Set up error responses using fixtures
        mockClient.setMockResponse("GET", "/not-found-endpoint", 
            FixtureLoader.createErrorResponse("not_found"));
        
        mockClient.setMockResponse("GET", "/unauthorized-endpoint", 
            FixtureLoader.createErrorResponse("unauthorized"));
        
        mockClient.setMockResponse("GET", "/server-error-endpoint", 
            FixtureLoader.createErrorResponse("server_error"));
        
        // Test 404 error
        var notFoundReceived = false;
        mockClient.get("/not-found-endpoint", null, null, function(response) {
            notFoundReceived = true;
            Assert.equals(404, response.status);
            Assert.isFalse(response.success);
            Assert.equals("Not Found", response.data.error);
        });
        Assert.isTrue(notFoundReceived);
        
        // Test 401 error
        var unauthorizedReceived = false;
        mockClient.get("/unauthorized-endpoint", null, null, function(response) {
            unauthorizedReceived = true;
            Assert.equals(401, response.status);
            Assert.isFalse(response.success);
            Assert.equals("Unauthorized", response.data.error);
        });
        Assert.isTrue(unauthorizedReceived);
        
        // Test 500 error
        var serverErrorReceived = false;
        mockClient.get("/server-error-endpoint", null, null, function(response) {
            serverErrorReceived = true;
            Assert.equals(500, response.status);
            Assert.isFalse(response.success);
            Assert.equals("Internal Server Error", response.data.error);
        });
        Assert.isTrue(serverErrorReceived);
    }
}