package test.spoton.endpoints;

import utest.Test;
import utest.Assert;
import spoton.endpoints.BaseEndpoint;
import spoton.http.HTTPClient;
import spoton.http.Response;
import spoton.auth.AuthenticationManager;
import spoton.errors.SpotOnException;
import spoton.errors.APIException;
import spoton.errors.NetworkException;
import spoton.errors.AuthenticationException;
import test.spoton.http.MockHTTPClient;
import test.spoton.auth.MockAuthenticationManager;

/**
 * Test class for BaseEndpoint functionality
 * Tests common endpoint functionality, authentication integration, and error handling
 */
class BaseEndpointTest extends Test {
    
    private var mockHttpClient: MockHTTPClient;
    private var mockAuth: MockAuthenticationManager;
    private var baseEndpoint: TestableBaseEndpoint;
    
    public function setup() {
        mockHttpClient = new MockHTTPClient();
        mockAuth = new MockAuthenticationManager();
        baseEndpoint = new TestableBaseEndpoint(mockHttpClient, mockAuth);
    }
    
    public function teardown() {
        mockHttpClient = null;
        mockAuth = null;
        baseEndpoint = null;
    }
    
    // Test endpoint initialization and configuration management
    
    public function testEndpointInitialization() {
        // Test that endpoint is properly initialized with dependencies
        Assert.notNull(baseEndpoint);
        
        // Test that endpoint can be created with valid dependencies
        var httpClient = new MockHTTPClient();
        var auth = new MockAuthenticationManager();
        var endpoint = new TestableBaseEndpoint(httpClient, auth);
        Assert.notNull(endpoint);
    }
    
    public function testEndpointInitializationWithNullDependencies() {
        // Test that endpoint can be created with null dependencies (they may be validated later)
        var endpoint1 = new TestableBaseEndpoint(null, mockAuth);
        Assert.notNull(endpoint1);
        
        var endpoint2 = new TestableBaseEndpoint(mockHttpClient, null);
        Assert.notNull(endpoint2);
        
        // The actual validation happens when making requests, not during construction
        Assert.pass();
    }
    
    // Test authentication integration
    
    public function testAuthenticationIntegration() {
        // Configure mock auth to return headers and set as authenticated
        mockAuth.setAuthenticationState(true);
        mockAuth.mockAuthHeaders = new Map<String, String>();
        mockAuth.mockAuthHeaders.set("Authorization", "Bearer test_token");
        mockAuth.mockAuthHeaders.set("X-API-Key", "test_api_key");
        
        // Configure mock HTTP client to return success response
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"success": true}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var responseData: Dynamic = null;
        
        // Make request and verify auth headers are included
        baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
            callbackCalled = true;
            responseData = response;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(responseData);
        Assert.equals(true, responseData.success);
        
        // Verify that auth headers were requested
        Assert.equals(1, mockAuth.getAuthHeadersCalls);
        
        // Verify that HTTP request was made with auth headers
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("GET", request.method);
        Assert.equals("/test", request.path);
        Assert.isTrue(request.headers.exists("Authorization"));
        Assert.equals("Bearer test_token", request.headers.get("Authorization"));
        Assert.isTrue(request.headers.exists("X-API-Key"));
        Assert.equals("test_api_key", request.headers.get("X-API-Key"));
    }
    
    public function testAuthenticationFailure() {
        // Configure mock auth to simulate authentication failure
        mockAuth.shouldAuthenticate = false;
        mockAuth.mockAuthHeaders = new Map<String, String>();
        
        // Configure mock HTTP client to return 401 response
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 401,
            headers: new Map<String, String>(),
            body: '{"error": "Unauthorized"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        var thrownException: Dynamic = null;
        
        try {
            baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called on authentication failure");
            });
        } catch (e: AuthenticationException) {
            exceptionThrown = true;
            thrownException = e;
        } catch (e: Dynamic) {
            Assert.fail("Should throw AuthenticationException, got: " + Type.getClassName(Type.getClass(e)));
        }
        
        Assert.isTrue(exceptionThrown);
        Assert.notNull(thrownException);
        Assert.equals("UNAUTHORIZED", thrownException.errorCode);
    }
    
    // Test HTTP client interaction
    
    public function testHttpClientInteraction() {
        // Test GET request
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"data": "test"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
            callbackCalled = true;
            Assert.equals("test", response.data);
        });
        
        Assert.isTrue(callbackCalled);
        Assert.equals(1, mockHttpClient.requestHistory.length);
        Assert.equals("GET", mockHttpClient.requestHistory[0].method);
    }
    
    public function testHttpClientInteractionWithData() {
        // Test POST request with data
        var testData = {name: "test", value: 123};
        
        mockHttpClient.setMockResponse("POST", "/test", {
            statusCode: 201,
            headers: new Map<String, String>(),
            body: '{"id": 1, "created": true}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        baseEndpoint.makeRequest("POST", "/test", testData, function(response: Dynamic) {
            callbackCalled = true;
            Assert.equals(1, response.id);
            Assert.equals(true, response.created);
        });
        
        Assert.isTrue(callbackCalled);
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("POST", request.method);
        Assert.equals("/test", request.path);
        Assert.notNull(request.data);
    }
    
    public function testHttpClientInteractionWithCustomHeaders() {
        // Test request with custom headers
        var customHeaders = new Map<String, String>();
        customHeaders.set("Content-Type", "application/json");
        customHeaders.set("X-Custom-Header", "custom-value");
        
        mockHttpClient.setMockResponse("PUT", "/test", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"updated": true}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        baseEndpoint.makeRequestWithHeaders("PUT", "/test", null, customHeaders, function(response: Dynamic) {
            callbackCalled = true;
            Assert.equals(true, response.updated);
        });
        
        Assert.isTrue(callbackCalled);
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("PUT", request.method);
        Assert.isTrue(request.headers.exists("Content-Type"));
        Assert.equals("application/json", request.headers.get("Content-Type"));
        Assert.isTrue(request.headers.exists("X-Custom-Header"));
        Assert.equals("custom-value", request.headers.get("X-Custom-Header"));
    }
    
    // Test error handling and response processing
    
    public function testHttpErrorHandling400() {
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 400,
            headers: new Map<String, String>(),
            body: '{"error": "Bad Request"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called on error");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("BAD_REQUEST", e.errorCode);
            Assert.equals(400, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testHttpErrorHandling404() {
        mockHttpClient.setMockResponse("GET", "/nonexistent", {
            statusCode: 404,
            headers: new Map<String, String>(),
            body: '{"error": "Not Found"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", "/nonexistent", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called on error");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("NOT_FOUND", e.errorCode);
            Assert.equals(404, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testHttpErrorHandling500() {
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 500,
            headers: new Map<String, String>(),
            body: '{"error": "Internal Server Error"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called on error");
            });
        } catch (e: APIException) {
            exceptionThrown = true;
            Assert.equals("INTERNAL_SERVER_ERROR", e.errorCode);
            Assert.equals(500, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testNetworkErrorHandling() {
        // Simulate network error
        mockHttpClient.simulateNetworkError = true;
        mockHttpClient.networkErrorMessage = "Connection timeout";
        
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called on network error");
            });
        } catch (e: NetworkException) {
            exceptionThrown = true;
            Assert.equals("NETWORK_ERROR", e.errorCode);
            Assert.isTrue(e.message.indexOf("Network Error") >= 0);
        } catch (e: Dynamic) {
            // Fallback for any other exception type
            exceptionThrown = true;
            var errorMessage = Std.string(e);
            Assert.isTrue(errorMessage.indexOf("Network") >= 0 || errorMessage.indexOf("Connection") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testResponseProcessingWithValidJson() {
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"name": "test", "count": 42, "active": true}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
            callbackCalled = true;
            Assert.equals("test", response.name);
            Assert.equals(42, response.count);
            Assert.equals(true, response.active);
        });
        
        Assert.isTrue(callbackCalled);
    }
    
    public function testResponseProcessingWithEmptyBody() {
        mockHttpClient.setMockResponse("DELETE", "/test", {
            statusCode: 204,
            headers: new Map<String, String>(),
            body: "",
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        baseEndpoint.makeRequest("DELETE", "/test", null, function(response: Dynamic) {
            callbackCalled = true;
            Assert.isNull(response);
        });
        
        Assert.isTrue(callbackCalled);
    }
    
    public function testResponseProcessingWithInvalidJson() {
        mockHttpClient.setMockResponse("GET", "/test", {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: 'invalid json {',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called on JSON parse error");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("JSON_PARSE_ERROR", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    // Test parameter validation
    
    public function testInvalidMethodValidation() {
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called with invalid method");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_METHOD", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testNullMethodValidation() {
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest(null, "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called with null method");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_METHOD", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testInvalidPathValidation() {
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", "", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called with invalid path");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_PATH", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testNullPathValidation() {
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("GET", null, null, function(response: Dynamic) {
                Assert.fail("Callback should not be called with null path");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("INVALID_PATH", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testUnsupportedMethodValidation() {
        var exceptionThrown = false;
        try {
            baseEndpoint.makeRequest("PATCH", "/test", null, function(response: Dynamic) {
                Assert.fail("Callback should not be called with unsupported method");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("UNSUPPORTED_METHOD", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testValidateParamsWithNullParams() {
        // Should not throw exception with null params
        baseEndpoint.validateParams(null);
        Assert.pass();
    }
    
    public function testValidateParamsWithValidParams() {
        // Should not throw exception with valid params
        var params = {id: 1, name: "test"};
        baseEndpoint.validateParams(params);
        Assert.pass();
    }
}

/**
 * Testable subclass of BaseEndpoint that exposes protected methods for testing
 */
class TestableBaseEndpoint extends BaseEndpoint {
    
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    // Expose protected methods for testing
    public override function validateParams(params: Dynamic): Void {
        super.validateParams(params);
    }
}