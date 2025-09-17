package test.spoton.endpoints;

import utest.Test;
import utest.Assert;
import spoton.endpoints.BusinessEndpoint;
import spoton.errors.SpotOnException;
import spoton.errors.APIException;
import test.spoton.http.MockHTTPClient;
import test.spoton.auth.MockAuthenticationManager;

/**
 * Test class for BusinessEndpoint functionality
 * Tests business-specific API methods including location retrieval and liveness checks
 */
class BusinessEndpointTest extends Test {
    
    private var mockHttpClient: MockHTTPClient;
    private var mockAuth: MockAuthenticationManager;
    private var businessEndpoint: BusinessEndpoint;
    
    public function setup() {
        mockHttpClient = new MockHTTPClient();
        mockAuth = new MockAuthenticationManager();
        mockAuth.setAuthenticationState(true);
        businessEndpoint = new BusinessEndpoint(mockHttpClient, mockAuth);
    }
    
    public function teardown() {
        mockHttpClient = null;
        mockAuth = null;
        businessEndpoint = null;
    }
    
    // Test liveness endpoint functionality
    
    public function testGetLivenessSuccess() {
        // Configure mock response for liveness check
        mockHttpClient.setMockResponse("GET", "/business/v1/livez", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"status": "ok", "timestamp": "2023-01-01T00:00:00Z"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseData: Dynamic = null;
        
        businessEndpoint.getLiveness(function(response: Dynamic) {
            callbackCalled = true;
            responseData = response;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseData);
        Assert.equals("ok", responseData.status);
        Assert.equals("2023-01-01T00:00:00Z", responseData.timestamp);
        
        // Verify correct HTTP request was made
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("GET", request.method);
        Assert.equals("/business/v1/livez", request.path);
        Assert.isNull(request.data);
    }
    
    public function testGetLivenessWithServiceUnavailable() {
        // Configure mock response for service unavailable
        mockHttpClient.setMockResponse("GET", "/business/v1/livez", {
            statusCode: 503,
            headers: new Map<String, String>(),
            body: '{"error": "Service temporarily unavailable"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            businessEndpoint.getLiveness(function(response: Dynamic) {
                Assert.fail("Callback should not be called on service unavailable");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("SERVICE_UNAVAILABLE", e.errorCode);
            Assert.equals(503, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetLivenessWithAuthenticationFailure() {
        // Configure mock auth to fail
        mockAuth.setAuthenticationState(false);
        
        mockHttpClient.setMockResponse("GET", "/business/v1/livez", {
            statusCode: 401,
            headers: new Map<String, String>(),
            body: '{"error": "Unauthorized"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            businessEndpoint.getLiveness(function(response: Dynamic) {
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
    
    // Test location retrieval functionality
    
    public function testGetLocationSuccess() {
        var locationId = "BL-1234-5678-9012";
        var expectedLocation = {
            id: locationId,
            name: "Test Restaurant",
            address: "123 Main St",
            city: "Test City",
            state: "TS",
            zip: "12345",
            phone: "555-0123",
            active: true
        };
        
        // Configure mock response for location retrieval
        mockHttpClient.setMockResponse("GET", "/business/v1/locations/" + locationId, {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(expectedLocation),
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseData: Dynamic = null;
        
        businessEndpoint.getLocation(locationId, function(response: Dynamic) {
            callbackCalled = true;
            responseData = response;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseData);
        Assert.equals(locationId, responseData.id);
        Assert.equals("Test Restaurant", responseData.name);
        Assert.equals("123 Main St", responseData.address);
        Assert.equals(true, responseData.active);
        
        // Verify correct HTTP request was made
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("GET", request.method);
        Assert.equals("/business/v1/locations/" + locationId, request.path);
        Assert.isNull(request.data);
    }
    
    public function testGetLocationNotFound() {
        var locationId = "BL-9999-9999-9999";
        
        // Configure mock response for location not found
        mockHttpClient.setMockResponse("GET", "/business/v1/locations/" + locationId, {
            statusCode: 404,
            headers: new Map<String, String>(),
            body: '{"error": "Location not found"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            businessEndpoint.getLocation(locationId, function(response: Dynamic) {
                Assert.fail("Callback should not be called when location not found");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("NOT_FOUND", e.errorCode);
            Assert.equals(404, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    // Test parameter validation
    
    public function testGetLocationWithNullLocationId() {
        var exceptionThrown = false;
        try {
            businessEndpoint.getLocation(null, function(response: Dynamic) {
                Assert.fail("Callback should not be called with null location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID cannot be null or empty") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetLocationWithEmptyLocationId() {
        var exceptionThrown = false;
        try {
            businessEndpoint.getLocation("", function(response: Dynamic) {
                Assert.fail("Callback should not be called with empty location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID cannot be null or empty") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testGetLocationWithInvalidLocationIdFormat() {
        var invalidLocationId = "invalid-format";
        
        // Configure mock response for bad request due to invalid format
        mockHttpClient.setMockResponse("GET", "/business/v1/locations/" + invalidLocationId, {
            statusCode: 400,
            headers: new Map<String, String>(),
            body: '{"error": "Invalid location ID format"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            businessEndpoint.getLocation(invalidLocationId, function(response: Dynamic) {
                Assert.fail("Callback should not be called with invalid location ID format");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("BAD_REQUEST", e.errorCode);
            Assert.equals(400, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    // Test authentication integration
    
    public function testLocationRequestIncludesAuthHeaders() {
        var locationId = "BL-1234-5678-9012";
        
        // Configure mock auth with specific headers
        mockAuth.setMockToken("test_business_token");
        mockAuth.setMockApiKey("test_business_api_key");
        
        mockHttpClient.setMockResponse("GET", "/business/v1/locations/" + locationId, {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"id": "' + locationId + '", "name": "Test Location"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        businessEndpoint.getLocation(locationId, function(response: Dynamic) {
            callbackCalled = true;
        });
        
        Assert.isTrue(callbackCalled);
        
        // Verify auth headers were included in request
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.isTrue(request.headers.exists("Authorization"));
        Assert.equals("Bearer test_business_token", request.headers.get("Authorization"));
        Assert.isTrue(request.headers.exists("X-API-Key"));
        Assert.equals("test_business_api_key", request.headers.get("X-API-Key"));
        
        // Verify auth headers were requested
        Assert.equals(1, mockAuth.getAuthHeadersCalls);
    }
    
    public function testLivenessRequestIncludesAuthHeaders() {
        // Configure mock auth with specific headers
        mockAuth.setMockToken("test_liveness_token");
        mockAuth.setMockApiKey("test_liveness_api_key");
        
        mockHttpClient.setMockResponse("GET", "/business/v1/livez", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"status": "ok"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        businessEndpoint.getLiveness(function(response: Dynamic) {
            callbackCalled = true;
        });
        
        Assert.isTrue(callbackCalled);
        
        // Verify auth headers were included in request
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.isTrue(request.headers.exists("Authorization"));
        Assert.equals("Bearer test_liveness_token", request.headers.get("Authorization"));
        Assert.isTrue(request.headers.exists("X-API-Key"));
        Assert.equals("test_liveness_api_key", request.headers.get("X-API-Key"));
        
        // Verify auth headers were requested
        Assert.equals(1, mockAuth.getAuthHeadersCalls);
    }
    
    // Test error handling edge cases
    
    public function testGetLocationWithNetworkError() {
        var locationId = "BL-1234-5678-9012";
        
        // Simulate network error
        mockHttpClient.simulateNetworkError = true;
        mockHttpClient.networkErrorMessage = "Connection timeout";
        
        var exceptionThrown = false;
        try {
            businessEndpoint.getLocation(locationId, function(response: Dynamic) {
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
    
    public function testGetLivenessWithInvalidJsonResponse() {
        mockHttpClient.setMockResponse("GET", "/business/v1/livez", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: 'invalid json response {',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            businessEndpoint.getLiveness(function(response: Dynamic) {
                Assert.fail("Callback should not be called with invalid JSON");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("JSON_PARSE_ERROR", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
}