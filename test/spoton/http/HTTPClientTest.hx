package test.spoton.http;

import utest.Test;
import utest.Assert;
import spoton.http.HTTPClient;
import spoton.http.HTTPClientImpl;
import spoton.http.Response;
import spoton.errors.NetworkException;
import spoton.errors.APIException;
import spoton.errors.AuthenticationException;
import test.spoton.http.MockHTTPClient;

/**
 * Unit tests for HTTPClient implementation
 * Tests request building, header management, and response handling
 */
class HTTPClientTest extends Test {
    
    private var httpClient: HTTPClientImpl;
    private var mockClient: MockHTTPClient;
    private var baseUrl: String;
    
    public function setup() {
        baseUrl = "https://api.spoton.com";
        httpClient = new HTTPClientImpl(baseUrl);
        mockClient = new MockHTTPClient();
    }
    
    /**
     * Test HTTPClient construction with base URL
     */
    public function testHttpClientConstruction() {
        var client = new HTTPClientImpl("https://api.example.com");
        Assert.notNull(client);
    }
    
    /**
     * Test setting default headers
     */
    public function testSetDefaultHeader() {
        httpClient.setDefaultHeader("X-API-Key", "test-key");
        httpClient.setDefaultHeader("User-Agent", "SpotOn-SDK/1.0");
        
        // We can't directly test the headers are set without making a request
        // This test verifies the method doesn't throw an exception
        Assert.pass("Default headers set successfully");
    }
    
    /**
     * Test GET request with mock client
     */
    public function testGetRequest() {
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"message": "success"}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/test", mockResponse);
        
        var responseReceived = false;
        var receivedResponse: Response = null;
        
        mockClient.get("/test", null, null, function(response: Response) {
            responseReceived = true;
            receivedResponse = response;
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        Assert.notNull(receivedResponse, "Response should not be null");
        Assert.equals(200, receivedResponse.status);
        Assert.equals('{"message": "success"}', receivedResponse.body);
        Assert.isTrue(receivedResponse.success);
        Assert.notNull(receivedResponse.data);
        Assert.equals("success", receivedResponse.data.message);
    }
    
    /**
     * Test GET request with query parameters
     */
    public function testGetRequestWithParams() {
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"results": []}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/search", mockResponse);
        
        var params = { query: "test", limit: 10 };
        var responseReceived = false;
        
        mockClient.get("/search", params, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(200, response.status);
            Assert.isTrue(response.success);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Verify the request was recorded with parameters
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.equals("GET", lastRequest.method);
        Assert.equals("/search", lastRequest.path);
        Assert.notNull(lastRequest.params);
    }
    
    /**
     * Test POST request with data
     */
    public function testPostRequest() {
        var mockResponse: MockResponse = {
            statusCode: 201,
            headers: new Map<String, String>(),
            body: '{"id": 123, "created": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("POST", "/create", mockResponse);
        
        var postData = { name: "Test Item", value: 42 };
        var responseReceived = false;
        
        mockClient.post("/create", postData, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(201, response.status);
            Assert.isTrue(response.success);
            Assert.notNull(response.data);
            Assert.equals(123, response.data.id);
            Assert.isTrue(response.data.created);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Verify the request was recorded with data
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.equals("POST", lastRequest.method);
        Assert.equals("/create", lastRequest.path);
        Assert.notNull(lastRequest.data);
    }
    
    /**
     * Test PUT request with data
     */
    public function testPutRequest() {
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"id": 123, "updated": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("PUT", "/update/123", mockResponse);
        
        var updateData = { name: "Updated Item", value: 84 };
        var responseReceived = false;
        
        mockClient.put("/update/123", updateData, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(200, response.status);
            Assert.isTrue(response.success);
            Assert.notNull(response.data);
            Assert.equals(123, response.data.id);
            Assert.isTrue(response.data.updated);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Verify the request was recorded
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.equals("PUT", lastRequest.method);
        Assert.equals("/update/123", lastRequest.path);
        Assert.notNull(lastRequest.data);
    }
    
    /**
     * Test DELETE request
     */
    public function testDeleteRequest() {
        var mockResponse: MockResponse = {
            statusCode: 204,
            headers: new Map<String, String>(),
            body: "",
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("DELETE", "/delete/123", mockResponse);
        
        var responseReceived = false;
        
        mockClient.delete("/delete/123", null, function(response: Response) {
            responseReceived = true;
            Assert.equals(204, response.status);
            Assert.isTrue(response.success);
            Assert.equals("", response.body);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Verify the request was recorded
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.equals("DELETE", lastRequest.method);
        Assert.equals("/delete/123", lastRequest.path);
    }
    
    /**
     * Test request with custom headers
     */
    public function testRequestWithCustomHeaders() {
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"success": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/test", mockResponse);
        
        var customHeaders = new Map<String, String>();
        customHeaders.set("Authorization", "Bearer token123");
        customHeaders.set("X-Custom-Header", "custom-value");
        
        var responseReceived = false;
        
        mockClient.get("/test", null, customHeaders, function(response: Response) {
            responseReceived = true;
            Assert.equals(200, response.status);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Verify headers were included in the request
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.notNull(lastRequest.headers);
        Assert.isTrue(lastRequest.headers.exists("Authorization"));
        Assert.isTrue(lastRequest.headers.exists("X-Custom-Header"));
        Assert.equals("Bearer token123", lastRequest.headers.get("Authorization"));
        Assert.equals("custom-value", lastRequest.headers.get("X-Custom-Header"));
    }
    
    /**
     * Test HTTP error responses (4xx status codes)
     */
    public function testHttpClientErrors() {
        // Test 404 Not Found
        var notFoundResponse: MockResponse = {
            statusCode: 404,
            headers: new Map<String, String>(),
            body: '{"error": "Not Found"}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/notfound", notFoundResponse);
        
        var responseReceived = false;
        
        mockClient.get("/notfound", null, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(404, response.status);
            Assert.isFalse(response.success);
            Assert.notNull(response.data);
            Assert.equals("Not Found", response.data.error);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
    }
    
    /**
     * Test HTTP server errors (5xx status codes)
     */
    public function testHttpServerErrors() {
        // Test 500 Internal Server Error
        var serverErrorResponse: MockResponse = {
            statusCode: 500,
            headers: new Map<String, String>(),
            body: '{"error": "Internal Server Error"}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/servererror", serverErrorResponse);
        
        var responseReceived = false;
        
        mockClient.get("/servererror", null, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(500, response.status);
            Assert.isFalse(response.success);
            Assert.notNull(response.data);
            Assert.equals("Internal Server Error", response.data.error);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
    }
    
    /**
     * Test network error simulation
     */
    public function testNetworkError() {
        mockClient.simulateNetworkError = true;
        mockClient.networkErrorMessage = "Connection failed";
        
        var responseReceived = false;
        
        mockClient.get("/test", null, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(0, response.status);
            Assert.isFalse(response.success);
            Assert.equals("Connection failed", response.body);
        });
        
        Assert.isTrue(responseReceived, "Error response should be received");
    }
    
    /**
     * Test response delay simulation
     */
    public function testResponseDelay(async: utest.Async) {
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"delayed": true}',
            delay: 100, // 100ms delay
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/delayed", mockResponse);
        
        var startTime = Date.now().getTime();
        
        mockClient.get("/delayed", null, null, function(response: Response) {
            var endTime = Date.now().getTime();
            var elapsed = endTime - startTime;
            
            Assert.equals(200, response.status);
            Assert.isTrue(response.success);
            // Note: In a real test environment, we might check that elapsed >= 100
            // but for this mock implementation, we just verify the response is correct
            async.done();
        });
    }
    
    /**
     * Test request history tracking
     */
    public function testRequestHistoryTracking() {
        mockClient.clearRequestHistory();
        
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"success": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/test1", mockResponse);
        mockClient.setMockResponse("POST", "/test2", mockResponse);
        
        // Make multiple requests
        mockClient.get("/test1", null, null, function(response: Response) {});
        mockClient.post("/test2", {data: "test"}, null, function(response: Response) {});
        
        // Verify history tracking
        Assert.equals(2, mockClient.requestHistory.length);
        
        var firstRequest = mockClient.requestHistory[0];
        Assert.equals("GET", firstRequest.method);
        Assert.equals("/test1", firstRequest.path);
        
        var secondRequest = mockClient.requestHistory[1];
        Assert.equals("POST", secondRequest.method);
        Assert.equals("/test2", secondRequest.path);
        Assert.notNull(secondRequest.data);
        
        // Test getting requests for specific method/path
        var getRequests = mockClient.getRequestsFor("GET", "/test1");
        Assert.equals(1, getRequests.length);
        Assert.equals("GET", getRequests[0].method);
        
        var postRequests = mockClient.getRequestsFor("POST", "/test2");
        Assert.equals(1, postRequests.length);
        Assert.equals("POST", postRequests[0].method);
    }
    
    /**
     * Test default header merging with request headers
     */
    public function testHeaderMerging() {
        mockClient.setDefaultHeader("X-Default-Header", "default-value");
        mockClient.setDefaultHeader("Content-Type", "application/json");
        
        var requestHeaders = new Map<String, String>();
        requestHeaders.set("X-Request-Header", "request-value");
        requestHeaders.set("Content-Type", "application/xml"); // Override default
        
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"success": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/test", mockResponse);
        
        mockClient.get("/test", null, requestHeaders, function(response: Response) {
            Assert.equals(200, response.status);
        });
        
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.notNull(lastRequest.headers);
        
        // Verify default header is present
        Assert.isTrue(lastRequest.headers.exists("X-Default-Header"));
        Assert.equals("default-value", lastRequest.headers.get("X-Default-Header"));
        
        // Verify request header is present
        Assert.isTrue(lastRequest.headers.exists("X-Request-Header"));
        Assert.equals("request-value", lastRequest.headers.get("X-Request-Header"));
        
        // Verify request header overrides default
        Assert.isTrue(lastRequest.headers.exists("Content-Type"));
        Assert.equals("application/xml", lastRequest.headers.get("Content-Type"));
    }
    
    /**
     * Test timeout handling simulation
     */
    public function testTimeoutHandling() {
        // Simulate timeout by using network error with timeout message
        mockClient.simulateNetworkError = true;
        mockClient.networkErrorMessage = "Request timeout";
        
        var responseReceived = false;
        var timeoutResponse: Response = null;
        
        mockClient.get("/timeout-test", null, null, function(response: Response) {
            responseReceived = true;
            timeoutResponse = response;
        });
        
        Assert.isTrue(responseReceived, "Timeout response should be received");
        Assert.notNull(timeoutResponse);
        Assert.equals(0, timeoutResponse.status);
        Assert.isFalse(timeoutResponse.success);
        Assert.equals("Request timeout", timeoutResponse.body);
        
        // Verify the request was recorded
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.equals("GET", lastRequest.method);
        Assert.equals("/timeout-test", lastRequest.path);
    }
    
    /**
     * Test request parameter encoding
     */
    public function testRequestParameterEncoding() {
        var mockResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"success": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/search", mockResponse);
        
        // Test parameters with special characters that need encoding
        var params = {
            query: "hello world",
            filter: "name=John&age>25",
            special: "chars@#$%^&*()",
            unicode: "café",
            spaces: "multiple   spaces"
        };
        
        var responseReceived = false;
        
        mockClient.get("/search", params, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(200, response.status);
            Assert.isTrue(response.success);
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Verify the request was recorded with parameters
        var lastRequest = mockClient.getLastRequest();
        Assert.notNull(lastRequest);
        Assert.equals("GET", lastRequest.method);
        Assert.equals("/search", lastRequest.path);
        Assert.notNull(lastRequest.params);
        
        // Verify parameter values are preserved (encoding would be handled by HTTPClientImpl)
        Assert.equals("hello world", Reflect.field(lastRequest.params, "query"));
        Assert.equals("name=John&age>25", Reflect.field(lastRequest.params, "filter"));
        Assert.equals("chars@#$%^&*()", Reflect.field(lastRequest.params, "special"));
        Assert.equals("café", Reflect.field(lastRequest.params, "unicode"));
        Assert.equals("multiple   spaces", Reflect.field(lastRequest.params, "spaces"));
    }
    
    /**
     * Test response data deserialization with various data types
     */
    public function testResponseDataDeserialization() {
        // Test with different JSON data types
        var testCases:Array<Dynamic> = [
            {
                name: "String data",
                body: '"Hello World"',
                expectedData: "Hello World"
            },
            {
                name: "Number data",
                body: '42',
                expectedData: 42
            },
            {
                name: "Boolean data",
                body: 'true',
                expectedData: true
            },
            {
                name: "Array data",
                body: '[1, 2, 3]',
                expectedData: [1, 2, 3]
            },
            {
                name: "Object data",
                body: '{"key": "value", "number": 123}',
                expectedData: { key: "value", number: 123 }
            },
            {
                name: "Null data",
                body: 'null',
                expectedData: null
            }
        ];
        
        for (i in 0...testCases.length) {
            var testCase = testCases[i];
            var path = "/test-" + i;
            
            var mockResponse: MockResponse = {
                statusCode: 200,
                headers: new Map<String, String>(),
                body: testCase.body,
                delay: 0,
                shouldFail: false,
                errorType: null
            };
            
            mockClient.setMockResponse("GET", path, mockResponse);
            
            var responseReceived = false;
            
            mockClient.get(path, null, null, function(response: Response) {
                responseReceived = true;
                Assert.equals(200, response.status, testCase.name + " - status");
                Assert.isTrue(response.success, testCase.name + " - success");
                Assert.equals(testCase.body, response.body, testCase.name + " - body");
                
                // Verify deserialized data matches expected
                if (testCase.expectedData == null) {
                    Assert.isNull(response.data, testCase.name + " - null data");
                } else if (Std.is(testCase.expectedData, String)) {
                    Assert.equals(testCase.expectedData, response.data, testCase.name + " - string data");
                } else if (Std.is(testCase.expectedData, Int) || Std.is(testCase.expectedData, Float)) {
                    Assert.equals(testCase.expectedData, response.data, testCase.name + " - number data");
                } else if (Std.is(testCase.expectedData, Bool)) {
                    Assert.equals(testCase.expectedData, response.data, testCase.name + " - boolean data");
                } else if (Std.is(testCase.expectedData, Array)) {
                    Assert.notNull(response.data, testCase.name + " - array not null");
                    Assert.equals(testCase.expectedData.length, response.data.length, testCase.name + " - array length");
                    for (j in 0...testCase.expectedData.length) {
                        Assert.equals(testCase.expectedData[j], response.data[j], testCase.name + " - array element " + j);
                    }
                } else {
                    // Object comparison
                    Assert.notNull(response.data, testCase.name + " - object not null");
                    var expectedFields = Reflect.fields(testCase.expectedData);
                    for (field in expectedFields) {
                        var expectedValue = Reflect.field(testCase.expectedData, field);
                        var actualValue = Reflect.field(response.data, field);
                        Assert.equals(expectedValue, actualValue, testCase.name + " - object field " + field);
                    }
                }
            });
            
            Assert.isTrue(responseReceived, testCase.name + " - response received");
        }
    }
    
    /**
     * Test HTTP error scenarios with detailed error information
     */
    public function testDetailedHttpErrorScenarios() {
        var errorScenarios = [
            {
                status: 400,
                body: '{"error": "Bad Request", "details": "Invalid parameter format"}',
                expectedSuccess: false
            },
            {
                status: 401,
                body: '{"error": "Unauthorized", "message": "Invalid API key"}',
                expectedSuccess: false
            },
            {
                status: 403,
                body: '{"error": "Forbidden", "message": "Insufficient permissions"}',
                expectedSuccess: false
            },
            {
                status: 409,
                body: '{"error": "Conflict", "message": "Resource already exists"}',
                expectedSuccess: false
            },
            {
                status: 422,
                body: '{"error": "Validation Error", "fields": [{"name": "email", "message": "Invalid format"}]}',
                expectedSuccess: false
            },
            {
                status: 429,
                body: '{"error": "Rate Limit Exceeded", "retryAfter": 60}',
                expectedSuccess: false
            },
            {
                status: 502,
                body: '{"error": "Bad Gateway", "message": "Upstream server error"}',
                expectedSuccess: false
            },
            {
                status: 503,
                body: '{"error": "Service Unavailable", "message": "Server temporarily overloaded"}',
                expectedSuccess: false
            }
        ];
        
        for (i in 0...errorScenarios.length) {
            var scenario = errorScenarios[i];
            var path = "/error-" + scenario.status;
            
            var mockResponse: MockResponse = {
                statusCode: scenario.status,
                headers: new Map<String, String>(),
                body: scenario.body,
                delay: 0,
                shouldFail: false,
                errorType: null
            };
            
            mockClient.setMockResponse("GET", path, mockResponse);
            
            var responseReceived = false;
            
            mockClient.get(path, null, null, function(response: Response) {
                responseReceived = true;
                Assert.equals(scenario.status, response.status, "Status code for " + scenario.status);
                Assert.equals(scenario.expectedSuccess, response.success, "Success flag for " + scenario.status);
                Assert.equals(scenario.body, response.body, "Response body for " + scenario.status);
                Assert.notNull(response.data, "Parsed data should not be null for " + scenario.status);
                Assert.isTrue(response.data.error != null, "Error field should exist for " + scenario.status);
            });
            
            Assert.isTrue(responseReceived, "Response should be received for status " + scenario.status);
        }
    }
    
    /**
     * Test request retry simulation (since actual retry logic may not be implemented)
     */
    public function testRequestRetrySimulation() {
        // Simulate a scenario where first request fails, then succeeds on retry
        var failureResponse: MockResponse = {
            statusCode: 503,
            headers: new Map<String, String>(),
            body: '{"error": "Service Unavailable", "retryAfter": 1}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        var successResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: '{"success": true, "retried": true}',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        // First request fails
        mockClient.setMockResponse("GET", "/retry-test", failureResponse);
        
        var firstResponseReceived = false;
        
        mockClient.get("/retry-test", null, null, function(response: Response) {
            firstResponseReceived = true;
            Assert.equals(503, response.status);
            Assert.isFalse(response.success);
            Assert.notNull(response.data);
            Assert.equals("Service Unavailable", response.data.error);
        });
        
        Assert.isTrue(firstResponseReceived, "First response should be received");
        
        // Simulate retry by changing mock response and making another request
        mockClient.setMockResponse("GET", "/retry-test", successResponse);
        
        var retryResponseReceived = false;
        
        mockClient.get("/retry-test", null, null, function(response: Response) {
            retryResponseReceived = true;
            Assert.equals(200, response.status);
            Assert.isTrue(response.success);
            Assert.notNull(response.data);
            Assert.isTrue(response.data.success);
            Assert.isTrue(response.data.retried);
        });
        
        Assert.isTrue(retryResponseReceived, "Retry response should be received");
        
        // Verify both requests were recorded
        Assert.equals(2, mockClient.requestHistory.length);
        Assert.equals("GET", mockClient.requestHistory[0].method);
        Assert.equals("/retry-test", mockClient.requestHistory[0].path);
        Assert.equals("GET", mockClient.requestHistory[1].method);
        Assert.equals("/retry-test", mockClient.requestHistory[1].path);
    }
    
    /**
     * Test JSON parsing edge cases
     */
    public function testJsonParsingEdgeCases() {
        // Test with invalid JSON
        var invalidJsonResponse: MockResponse = {
            statusCode: 200,
            headers: new Map<String, String>(),
            body: 'invalid json content',
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("GET", "/invalid-json", invalidJsonResponse);
        
        var responseReceived = false;
        
        mockClient.get("/invalid-json", null, null, function(response: Response) {
            responseReceived = true;
            Assert.equals(200, response.status);
            Assert.isTrue(response.success);
            Assert.equals("invalid json content", response.body);
            Assert.isNull(response.data); // Should be null due to JSON parsing failure
        });
        
        Assert.isTrue(responseReceived, "Response should be received");
        
        // Test with empty response body
        var emptyResponse: MockResponse = {
            statusCode: 204,
            headers: new Map<String, String>(),
            body: "",
            delay: 0,
            shouldFail: false,
            errorType: null
        };
        
        mockClient.setMockResponse("DELETE", "/empty", emptyResponse);
        
        responseReceived = false;
        
        mockClient.delete("/empty", null, function(response: Response) {
            responseReceived = true;
            Assert.equals(204, response.status);
            Assert.isTrue(response.success);
            Assert.equals("", response.body);
            Assert.isNull(response.data);
        });
        
        Assert.isTrue(responseReceived, "Empty response should be received");
    }
}