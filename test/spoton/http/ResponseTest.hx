package test.spoton.http;

import utest.Test;
import utest.Assert;
import spoton.http.Response;

/**
 * Unit tests for Response typedef
 * Tests response parsing, status code handling, and error responses
 */
class ResponseTest extends Test {
    
    /**
     * Test creating a successful response
     */
    public function testCreateSuccessfulResponse() {
        var headers = new Map<String, String>();
        headers.set("Content-Type", "application/json");
        headers.set("X-Request-ID", "12345");
        
        var responseData = { id: 123, name: "Test Item" };
        
        var response: Response = {
            status: 200,
            headers: headers,
            body: '{"id": 123, "name": "Test Item"}',
            data: responseData,
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.equals('{"id": 123, "name": "Test Item"}', response.body);
        Assert.notNull(response.data);
        Assert.equals(123, response.data.id);
        Assert.equals("Test Item", response.data.name);
        Assert.notNull(response.headers);
        Assert.equals("application/json", response.headers.get("Content-Type"));
        Assert.equals("12345", response.headers.get("X-Request-ID"));
    }
    
    /**
     * Test creating an error response
     */
    public function testCreateErrorResponse() {
        var headers = new Map<String, String>();
        headers.set("Content-Type", "application/json");
        
        var errorData = { error: "Not Found", code: "RESOURCE_NOT_FOUND" };
        
        var response: Response = {
            status: 404,
            headers: headers,
            body: '{"error": "Not Found", "code": "RESOURCE_NOT_FOUND"}',
            data: errorData,
            success: false
        };
        
        Assert.equals(404, response.status);
        Assert.isFalse(response.success);
        Assert.notNull(response.data);
        Assert.equals("Not Found", response.data.error);
        Assert.equals("RESOURCE_NOT_FOUND", response.data.code);
    }
    
    /**
     * Test response with various HTTP status codes
     */
    public function testResponseStatusCodes() {
        // Test 2xx success codes
        var successCodes = [200, 201, 202, 204];
        for (code in successCodes) {
            var response: Response = {
                status: code,
                headers: new Map<String, String>(),
                body: "",
                data: null,
                success: (code >= 200 && code < 300)
            };
            
            Assert.equals(code, response.status);
            Assert.isTrue(response.success, "Status " + code + " should be successful");
        }
        
        // Test 4xx client error codes
        var clientErrorCodes = [400, 401, 403, 404, 409, 422, 429];
        for (code in clientErrorCodes) {
            var response: Response = {
                status: code,
                headers: new Map<String, String>(),
                body: "",
                data: null,
                success: (code >= 200 && code < 300)
            };
            
            Assert.equals(code, response.status);
            Assert.isFalse(response.success, "Status " + code + " should not be successful");
        }
        
        // Test 5xx server error codes
        var serverErrorCodes = [500, 502, 503, 504];
        for (code in serverErrorCodes) {
            var response: Response = {
                status: code,
                headers: new Map<String, String>(),
                body: "",
                data: null,
                success: (code >= 200 && code < 300)
            };
            
            Assert.equals(code, response.status);
            Assert.isFalse(response.success, "Status " + code + " should not be successful");
        }
    }
    
    /**
     * Test response with empty body
     */
    public function testResponseWithEmptyBody() {
        var response: Response = {
            status: 204,
            headers: new Map<String, String>(),
            body: "",
            data: null,
            success: true
        };
        
        Assert.equals(204, response.status);
        Assert.isTrue(response.success);
        Assert.equals("", response.body);
        Assert.isNull(response.data);
    }
    
    /**
     * Test response with null data
     */
    public function testResponseWithNullData() {
        var response: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: "non-json content",
            data: null,
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.equals("non-json content", response.body);
        Assert.isNull(response.data);
    }
    
    /**
     * Test response headers manipulation
     */
    public function testResponseHeaders() {
        var headers = new Map<String, String>();
        headers.set("Content-Type", "application/json");
        headers.set("Cache-Control", "no-cache");
        headers.set("X-Rate-Limit-Remaining", "99");
        
        var response: Response = {
            status: 200,
            headers: headers,
            body: '{"success": true}',
            data: { success: true },
            success: true
        };
        
        Assert.notNull(response.headers);
        Assert.equals("application/json", response.headers.get("Content-Type"));
        Assert.equals("no-cache", response.headers.get("Cache-Control"));
        Assert.equals("99", response.headers.get("X-Rate-Limit-Remaining"));
        
        // Test header existence
        Assert.isTrue(response.headers.exists("Content-Type"));
        Assert.isTrue(response.headers.exists("Cache-Control"));
        Assert.isTrue(response.headers.exists("X-Rate-Limit-Remaining"));
        Assert.isFalse(response.headers.exists("Non-Existent-Header"));
        
        // Test case sensitivity (headers should be case-sensitive in our implementation)
        Assert.isFalse(response.headers.exists("content-type"));
        Assert.isFalse(response.headers.exists("CONTENT-TYPE"));
    }
    
    /**
     * Test response with complex JSON data
     */
    public function testResponseWithComplexJsonData() {
        var complexData = {
            user: {
                id: 123,
                name: "John Doe",
                email: "john@example.com",
                preferences: {
                    theme: "dark",
                    notifications: true
                }
            },
            items: [
                { id: 1, name: "Item 1", price: 10.99 },
                { id: 2, name: "Item 2", price: 25.50 }
            ],
            metadata: {
                total: 2,
                page: 1,
                hasMore: false
            }
        };
        
        var response: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(complexData),
            data: complexData,
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.notNull(response.data);
        
        // Test nested object access
        Assert.equals(123, response.data.user.id);
        Assert.equals("John Doe", response.data.user.name);
        Assert.equals("john@example.com", response.data.user.email);
        Assert.equals("dark", response.data.user.preferences.theme);
        Assert.isTrue(response.data.user.preferences.notifications);
        
        // Test array access
        Assert.equals(2, response.data.items.length);
        Assert.equals(1, response.data.items[0].id);
        Assert.equals("Item 1", response.data.items[0].name);
        Assert.equals(10.99, response.data.items[0].price);
        
        // Test metadata
        Assert.equals(2, response.data.metadata.total);
        Assert.equals(1, response.data.metadata.page);
        Assert.isFalse(response.data.metadata.hasMore);
    }
    
    /**
     * Test response with array data
     */
    public function testResponseWithArrayData() {
        var arrayData = [
            { id: 1, name: "First" },
            { id: 2, name: "Second" },
            { id: 3, name: "Third" }
        ];
        
        var response: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(arrayData),
            data: arrayData,
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.notNull(response.data);
        
        // Verify array structure
        Assert.equals(3, response.data.length);
        Assert.equals(1, response.data[0].id);
        Assert.equals("First", response.data[0].name);
        Assert.equals(2, response.data[1].id);
        Assert.equals("Second", response.data[1].name);
        Assert.equals(3, response.data[2].id);
        Assert.equals("Third", response.data[2].name);
    }
    
    /**
     * Test response with different content types
     */
    public function testResponseWithDifferentContentTypes() {
        // JSON response
        var jsonHeaders = new Map<String, String>();
        jsonHeaders.set("Content-Type", "application/json");
        
        var jsonResponse: Response = {
            status: 200,
            headers: jsonHeaders,
            body: '{"type": "json"}',
            data: { type: "json" },
            success: true
        };
        
        Assert.equals("application/json", jsonResponse.headers.get("Content-Type"));
        Assert.notNull(jsonResponse.data);
        Assert.equals("json", jsonResponse.data.type);
        
        // Text response
        var textHeaders = new Map<String, String>();
        textHeaders.set("Content-Type", "text/plain");
        
        var textResponse: Response = {
            status: 200,
            headers: textHeaders,
            body: "Plain text content",
            data: null,
            success: true
        };
        
        Assert.equals("text/plain", textResponse.headers.get("Content-Type"));
        Assert.equals("Plain text content", textResponse.body);
        Assert.isNull(textResponse.data);
        
        // XML response
        var xmlHeaders = new Map<String, String>();
        xmlHeaders.set("Content-Type", "application/xml");
        
        var xmlResponse: Response = {
            status: 200,
            headers: xmlHeaders,
            body: "<root><item>value</item></root>",
            data: null,
            success: true
        };
        
        Assert.equals("application/xml", xmlResponse.headers.get("Content-Type"));
        Assert.equals("<root><item>value</item></root>", xmlResponse.body);
        Assert.isNull(xmlResponse.data);
    }
    
    /**
     * Test response error scenarios
     */
    public function testResponseErrorScenarios() {
        // Authentication error
        var authErrorResponse: Response = {
            status: 401,
            headers: new Map<String, String>(),
            body: '{"error": "Unauthorized", "message": "Invalid API key"}',
            data: { error: "Unauthorized", message: "Invalid API key" },
            success: false
        };
        
        Assert.equals(401, authErrorResponse.status);
        Assert.isFalse(authErrorResponse.success);
        Assert.equals("Unauthorized", authErrorResponse.data.error);
        Assert.equals("Invalid API key", authErrorResponse.data.message);
        
        // Validation error
        var validationErrorResponse: Response = {
            status: 422,
            headers: new Map<String, String>(),
            body: '{"error": "Validation failed", "details": [{"field": "email", "message": "Invalid format"}]}',
            data: { 
                error: "Validation failed", 
                details: [{ field: "email", message: "Invalid format" }] 
            },
            success: false
        };
        
        Assert.equals(422, validationErrorResponse.status);
        Assert.isFalse(validationErrorResponse.success);
        Assert.equals("Validation failed", validationErrorResponse.data.error);
        Assert.equals(1, validationErrorResponse.data.details.length);
        Assert.equals("email", validationErrorResponse.data.details[0].field);
        Assert.equals("Invalid format", validationErrorResponse.data.details[0].message);
        
        // Server error
        var serverErrorResponse: Response = {
            status: 500,
            headers: new Map<String, String>(),
            body: '{"error": "Internal Server Error", "requestId": "req_12345"}',
            data: { error: "Internal Server Error", requestId: "req_12345" },
            success: false
        };
        
        Assert.equals(500, serverErrorResponse.status);
        Assert.isFalse(serverErrorResponse.success);
        Assert.equals("Internal Server Error", serverErrorResponse.data.error);
        Assert.equals("req_12345", serverErrorResponse.data.requestId);
    }
    
    /**
     * Test response with special characters and encoding
     */
    public function testResponseWithSpecialCharacters() {
        var specialData = {
            message: "Hello, 世界! 🌍",
            symbols: "Special chars: @#$%^&*()_+-={}[]|\\:;\"'<>,.?/",
            unicode: "Unicode: αβγδε ñáéíóú"
        };
        
        var response: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(specialData),
            data: specialData,
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.notNull(response.data);
        Assert.equals("Hello, 世界! 🌍", response.data.message);
        Assert.equals("Special chars: @#$%^&*()_+-={}[]|\\:;\"'<>,.?/", response.data.symbols);
        Assert.equals("Unicode: αβγδε ñáéíóú", response.data.unicode);
    }
    
    /**
     * Test response boundary conditions
     */
    public function testResponseBoundaryConditions() {
        // Test with status code 0 (network error)
        var networkErrorResponse: Response = {
            status: 0,
            headers: new Map<String, String>(),
            body: "Network error",
            data: null,
            success: false
        };
        
        Assert.equals(0, networkErrorResponse.status);
        Assert.isFalse(networkErrorResponse.success);
        Assert.equals("Network error", networkErrorResponse.body);
        Assert.isNull(networkErrorResponse.data);
        
        // Test with very large status code
        var unusualStatusResponse: Response = {
            status: 999,
            headers: new Map<String, String>(),
            body: "",
            data: null,
            success: false
        };
        
        Assert.equals(999, unusualStatusResponse.status);
        Assert.isFalse(unusualStatusResponse.success);
        
        // Test with boundary success status codes
        var boundary199Response: Response = {
            status: 199,
            headers: new Map<String, String>(),
            body: "",
            data: null,
            success: (199 >= 200 && 199 < 300)
        };
        
        Assert.equals(199, boundary199Response.status);
        Assert.isFalse(boundary199Response.success);
        
        var boundary300Response: Response = {
            status: 300,
            headers: new Map<String, String>(),
            body: "",
            data: null,
            success: (300 >= 200 && 300 < 300)
        };
        
        Assert.equals(300, boundary300Response.status);
        Assert.isFalse(boundary300Response.success);
    }
    
    /**
     * Test response data deserialization edge cases
     */
    public function testResponseDataDeserializationEdgeCases() {
        // Test with malformed JSON
        var malformedJsonResponse: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: '{"incomplete": json',
            data: null, // Should be null due to parsing failure
            success: true
        };
        
        Assert.equals(200, malformedJsonResponse.status);
        Assert.isTrue(malformedJsonResponse.success);
        Assert.equals('{"incomplete": json', malformedJsonResponse.body);
        Assert.isNull(malformedJsonResponse.data);
        
        // Test with empty JSON object
        var emptyObjectResponse: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: '{}',
            data: {},
            success: true
        };
        
        Assert.equals(200, emptyObjectResponse.status);
        Assert.isTrue(emptyObjectResponse.success);
        Assert.equals('{}', emptyObjectResponse.body);
        Assert.notNull(emptyObjectResponse.data);
        
        // Test with empty JSON array
        var emptyArrayResponse: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: '[]',
            data: [],
            success: true
        };
        
        Assert.equals(200, emptyArrayResponse.status);
        Assert.isTrue(emptyArrayResponse.success);
        Assert.equals('[]', emptyArrayResponse.body);
        Assert.notNull(emptyArrayResponse.data);
        Assert.equals(0, emptyArrayResponse.data.length);
        
        // Test with nested null values
        var nestedNullResponse: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: '{"value": null, "nested": {"inner": null}}',
            data: { value: null, nested: { inner: null } },
            success: true
        };
        
        Assert.equals(200, nestedNullResponse.status);
        Assert.isTrue(nestedNullResponse.success);
        Assert.notNull(nestedNullResponse.data);
        Assert.isNull(nestedNullResponse.data.value);
        Assert.notNull(nestedNullResponse.data.nested);
        Assert.isNull(nestedNullResponse.data.nested.inner);
    }
    
    /**
     * Test response with timeout-related status codes
     */
    public function testTimeoutRelatedResponses() {
        // Test 408 Request Timeout
        var requestTimeoutResponse: Response = {
            status: 408,
            headers: new Map<String, String>(),
            body: '{"error": "Request Timeout", "message": "Client did not produce a request within the time that the server was prepared to wait"}',
            data: { 
                error: "Request Timeout", 
                message: "Client did not produce a request within the time that the server was prepared to wait" 
            },
            success: false
        };
        
        Assert.equals(408, requestTimeoutResponse.status);
        Assert.isFalse(requestTimeoutResponse.success);
        Assert.equals("Request Timeout", requestTimeoutResponse.data.error);
        
        // Test 504 Gateway Timeout
        var gatewayTimeoutResponse: Response = {
            status: 504,
            headers: new Map<String, String>(),
            body: '{"error": "Gateway Timeout", "message": "Upstream server timeout"}',
            data: { error: "Gateway Timeout", message: "Upstream server timeout" },
            success: false
        };
        
        Assert.equals(504, gatewayTimeoutResponse.status);
        Assert.isFalse(gatewayTimeoutResponse.success);
        Assert.equals("Gateway Timeout", gatewayTimeoutResponse.data.error);
        Assert.equals("Upstream server timeout", gatewayTimeoutResponse.data.message);
    }
    
    /**
     * Test response header parsing and access
     */
    public function testResponseHeaderParsing() {
        var headers = new Map<String, String>();
        headers.set("Content-Type", "application/json; charset=utf-8");
        headers.set("Content-Length", "1234");
        headers.set("Cache-Control", "no-cache, no-store, must-revalidate");
        headers.set("X-Rate-Limit-Limit", "1000");
        headers.set("X-Rate-Limit-Remaining", "999");
        headers.set("X-Rate-Limit-Reset", "1640995200");
        headers.set("ETag", '"abc123"');
        headers.set("Last-Modified", "Wed, 21 Oct 2015 07:28:00 GMT");
        
        var response: Response = {
            status: 200,
            headers: headers,
            body: '{"data": "test"}',
            data: { data: "test" },
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.notNull(response.headers);
        
        // Test header access
        Assert.equals("application/json; charset=utf-8", response.headers.get("Content-Type"));
        Assert.equals("1234", response.headers.get("Content-Length"));
        Assert.equals("no-cache, no-store, must-revalidate", response.headers.get("Cache-Control"));
        Assert.equals("1000", response.headers.get("X-Rate-Limit-Limit"));
        Assert.equals("999", response.headers.get("X-Rate-Limit-Remaining"));
        Assert.equals("1640995200", response.headers.get("X-Rate-Limit-Reset"));
        Assert.equals('"abc123"', response.headers.get("ETag"));
        Assert.equals("Wed, 21 Oct 2015 07:28:00 GMT", response.headers.get("Last-Modified"));
        
        // Test header existence
        Assert.isTrue(response.headers.exists("Content-Type"));
        Assert.isTrue(response.headers.exists("X-Rate-Limit-Limit"));
        Assert.isFalse(response.headers.exists("Non-Existent-Header"));
        
        // Test case sensitivity
        Assert.isFalse(response.headers.exists("content-type"));
        Assert.isFalse(response.headers.exists("CONTENT-TYPE"));
    }
    
    /**
     * Test response with large data payloads
     */
    public function testResponseWithLargeData() {
        // Create a large data structure
        var largeArray = [];
        for (i in 0...1000) {
            largeArray.push({
                id: i,
                name: "Item " + i,
                description: "This is a description for item number " + i,
                value: i * 1.5,
                active: (i % 2 == 0)
            });
        }
        
        var largeData = {
            items: largeArray,
            total: 1000,
            metadata: {
                generated: "2024-01-01T00:00:00Z",
                version: "1.0",
                checksum: "abc123def456"
            }
        };
        
        var response: Response = {
            status: 200,
            headers: new Map<String, String>(),
            body: haxe.Json.stringify(largeData),
            data: largeData,
            success: true
        };
        
        Assert.equals(200, response.status);
        Assert.isTrue(response.success);
        Assert.notNull(response.data);
        Assert.equals(1000, response.data.total);
        Assert.equals(1000, response.data.items.length);
        
        // Test first and last items
        Assert.equals(0, response.data.items[0].id);
        Assert.equals("Item 0", response.data.items[0].name);
        Assert.isTrue(response.data.items[0].active);
        
        Assert.equals(999, response.data.items[999].id);
        Assert.equals("Item 999", response.data.items[999].name);
        Assert.isFalse(response.data.items[999].active);
        
        // Test metadata
        Assert.notNull(response.data.metadata);
        Assert.equals("2024-01-01T00:00:00Z", response.data.metadata.generated);
        Assert.equals("1.0", response.data.metadata.version);
        Assert.equals("abc123def456", response.data.metadata.checksum);
    }
}