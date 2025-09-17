package test.spoton.errors;

import utest.Test;
import utest.Assert;
import spoton.errors.SpotOnException;
import spoton.errors.APIException;
import spoton.errors.AuthenticationException;
import spoton.errors.NetworkException;

/**
 * Unit tests for SpotOn exception classes
 * Tests custom exception classes, error message formatting, exception hierarchy,
 * error propagation through SDK layers, and error handling in various failure scenarios
 */
class SpotOnExceptionTest extends Test {
    
    private var testMessage: String;
    private var testCode: String;
    private var testDetails: Dynamic;
    private var testHttpStatus: Int;
    private var testEndpoint: String;
    
    public function setup() {
        testMessage = "Test error message";
        testCode = "TEST_ERROR_CODE";
        testDetails = { additionalInfo: "test details", timestamp: 1234567890 };
        testHttpStatus = 400;
        testEndpoint = "/api/v1/test";
    }
    
    /**
     * Test SpotOnException basic functionality
     */
    public function testSpotOnExceptionBasicFunctionality() {
        var exception = new SpotOnException(testMessage, testCode, testDetails);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.equals(testDetails, exception.errorDetails, "Error details should match");
        Assert.equals(testCode, exception.getErrorCode(), "getErrorCode() should return correct code");
        Assert.equals(testDetails, exception.getErrorDetails(), "getErrorDetails() should return correct details");
    }
    
    /**
     * Test SpotOnException without details
     */
    public function testSpotOnExceptionWithoutDetails() {
        var exception = new SpotOnException(testMessage, testCode);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.isNull(exception.errorDetails, "Error details should be null when not provided");
        Assert.isNull(exception.getErrorDetails(), "getErrorDetails() should return null when not provided");
    }
    
    /**
     * Test SpotOnException inheritance from haxe.Exception
     */
    public function testSpotOnExceptionInheritance() {
        var exception = new SpotOnException(testMessage, testCode, testDetails);
        
        Assert.isTrue(Std.isOfType(exception, haxe.Exception), "SpotOnException should extend haxe.Exception");
        Assert.isTrue(Std.isOfType(exception, SpotOnException), "Should be instance of SpotOnException");
    }
    
    /**
     * Test APIException basic functionality
     */
    public function testAPIExceptionBasicFunctionality() {
        var exception = new APIException(testMessage, testCode, testHttpStatus, testEndpoint, testDetails);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.equals(testDetails, exception.errorDetails, "Error details should match");
        Assert.equals(testHttpStatus, exception.httpStatus, "HTTP status should match");
        Assert.equals(testEndpoint, exception.endpoint, "Endpoint should match");
        Assert.equals(testHttpStatus, exception.getHttpStatus(), "getHttpStatus() should return correct status");
        Assert.equals(testEndpoint, exception.getEndpoint(), "getEndpoint() should return correct endpoint");
    }
    
    /**
     * Test APIException without details
     */
    public function testAPIExceptionWithoutDetails() {
        var exception = new APIException(testMessage, testCode, testHttpStatus, testEndpoint);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.isNull(exception.errorDetails, "Error details should be null when not provided");
        Assert.equals(testHttpStatus, exception.httpStatus, "HTTP status should match");
        Assert.equals(testEndpoint, exception.endpoint, "Endpoint should match");
    }
    
    /**
     * Test APIException inheritance hierarchy
     */
    public function testAPIExceptionInheritance() {
        var exception = new APIException(testMessage, testCode, testHttpStatus, testEndpoint, testDetails);
        
        Assert.isTrue(Std.isOfType(exception, haxe.Exception), "APIException should extend haxe.Exception");
        Assert.isTrue(Std.isOfType(exception, SpotOnException), "APIException should extend SpotOnException");
        Assert.isTrue(Std.isOfType(exception, APIException), "Should be instance of APIException");
    }
    
    /**
     * Test AuthenticationException basic functionality
     */
    public function testAuthenticationExceptionBasicFunctionality() {
        var exception = new AuthenticationException(testMessage, testCode, testDetails);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.equals(testDetails, exception.errorDetails, "Error details should match");
        Assert.equals(testCode, exception.getErrorCode(), "getErrorCode() should return correct code");
        Assert.equals(testDetails, exception.getErrorDetails(), "getErrorDetails() should return correct details");
    }
    
    /**
     * Test AuthenticationException without details
     */
    public function testAuthenticationExceptionWithoutDetails() {
        var exception = new AuthenticationException(testMessage, testCode);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.isNull(exception.errorDetails, "Error details should be null when not provided");
    }
    
    /**
     * Test AuthenticationException inheritance hierarchy
     */
    public function testAuthenticationExceptionInheritance() {
        var exception = new AuthenticationException(testMessage, testCode, testDetails);
        
        Assert.isTrue(Std.isOfType(exception, haxe.Exception), "AuthenticationException should extend haxe.Exception");
        Assert.isTrue(Std.isOfType(exception, SpotOnException), "AuthenticationException should extend SpotOnException");
        Assert.isTrue(Std.isOfType(exception, AuthenticationException), "Should be instance of AuthenticationException");
    }
    
    /**
     * Test NetworkException basic functionality
     */
    public function testNetworkExceptionBasicFunctionality() {
        var exception = new NetworkException(testMessage, testCode, testDetails);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.equals(testDetails, exception.errorDetails, "Error details should match");
        Assert.equals(testCode, exception.getErrorCode(), "getErrorCode() should return correct code");
        Assert.equals(testDetails, exception.getErrorDetails(), "getErrorDetails() should return correct details");
    }
    
    /**
     * Test NetworkException without details
     */
    public function testNetworkExceptionWithoutDetails() {
        var exception = new NetworkException(testMessage, testCode);
        
        Assert.equals(testMessage, exception.message, "Exception message should match");
        Assert.equals(testCode, exception.errorCode, "Error code should match");
        Assert.isNull(exception.errorDetails, "Error details should be null when not provided");
    }
    
    /**
     * Test NetworkException inheritance hierarchy
     */
    public function testNetworkExceptionInheritance() {
        var exception = new NetworkException(testMessage, testCode, testDetails);
        
        Assert.isTrue(Std.isOfType(exception, haxe.Exception), "NetworkException should extend haxe.Exception");
        Assert.isTrue(Std.isOfType(exception, SpotOnException), "NetworkException should extend SpotOnException");
        Assert.isTrue(Std.isOfType(exception, NetworkException), "Should be instance of NetworkException");
    }
    
    /**
     * Test error message formatting with various scenarios
     */
    public function testErrorMessageFormatting() {
        // Test with empty message
        var emptyException = new SpotOnException("", testCode, testDetails);
        Assert.equals("", emptyException.message, "Empty message should be preserved");
        
        // Test with null message (should not crash)
        var nullException = new SpotOnException(null, testCode, testDetails);
        Assert.isNull(nullException.message, "Null message should be preserved");
        
        // Test with long message
        var longMessage = "This is a very long error message that contains multiple sentences and should be handled properly by the exception system without truncation or modification.";
        var longException = new SpotOnException(longMessage, testCode, testDetails);
        Assert.equals(longMessage, longException.message, "Long message should be preserved");
        
        // Test with special characters
        var specialMessage = "Error with special chars: àáâãäåæçèéêë ñòóôõö ùúûüý ÿ";
        var specialException = new SpotOnException(specialMessage, testCode, testDetails);
        Assert.equals(specialMessage, specialException.message, "Special characters should be preserved");
    }
    
    /**
     * Test error code formatting and validation
     */
    public function testErrorCodeFormatting() {
        // Test with empty code
        var emptyCodeException = new SpotOnException(testMessage, "", testDetails);
        Assert.equals("", emptyCodeException.errorCode, "Empty error code should be preserved");
        
        // Test with null code
        var nullCodeException = new SpotOnException(testMessage, null, testDetails);
        Assert.isNull(nullCodeException.errorCode, "Null error code should be preserved");
        
        // Test with uppercase code
        var upperCode = "UPPER_CASE_ERROR_CODE";
        var upperException = new SpotOnException(testMessage, upperCode, testDetails);
        Assert.equals(upperCode, upperException.errorCode, "Uppercase error code should be preserved");
        
        // Test with mixed case code
        var mixedCode = "Mixed_Case_Error_Code";
        var mixedException = new SpotOnException(testMessage, mixedCode, testDetails);
        Assert.equals(mixedCode, mixedException.errorCode, "Mixed case error code should be preserved");
    }
    
    /**
     * Test error details with various data types
     */
    public function testErrorDetailsVariousTypes() {
        // Test with string details
        var stringDetails = "Simple string details";
        var stringException = new SpotOnException(testMessage, testCode, stringDetails);
        Assert.equals(stringDetails, stringException.errorDetails, "String details should be preserved");
        
        // Test with number details
        var numberDetails = 42;
        var numberException = new SpotOnException(testMessage, testCode, numberDetails);
        Assert.equals(numberDetails, numberException.errorDetails, "Number details should be preserved");
        
        // Test with boolean details
        var boolDetails = true;
        var boolException = new SpotOnException(testMessage, testCode, boolDetails);
        Assert.equals(boolDetails, boolException.errorDetails, "Boolean details should be preserved");
        
        // Test with array details
        var arrayDetails: Array<Dynamic> = ["item1", "item2", "item3"];
        var arrayException = new SpotOnException(testMessage, testCode, arrayDetails);
        Assert.equals(arrayDetails, arrayException.errorDetails, "Array details should be preserved");
        
        // Test with complex object details
        var complexDetails = {
            errorType: "validation",
            field: "email",
            value: "invalid-email",
            constraints: ["required", "email_format"],
            timestamp: 1234567890
        };
        var complexException = new SpotOnException(testMessage, testCode, complexDetails);
        Assert.equals(complexDetails, complexException.errorDetails, "Complex object details should be preserved");
    }
    
    /**
     * Test exception throwing and catching
     */
    public function testExceptionThrowingAndCatching() {
        // Test throwing and catching SpotOnException
        var caughtSpotOnException = false;
        try {
            throw new SpotOnException(testMessage, testCode, testDetails);
        } catch (e: SpotOnException) {
            caughtSpotOnException = true;
            Assert.equals(testMessage, e.message, "Caught exception should have correct message");
            Assert.equals(testCode, e.errorCode, "Caught exception should have correct code");
        } catch (e: Dynamic) {
            Assert.fail("Should catch as SpotOnException, not generic exception");
        }
        Assert.isTrue(caughtSpotOnException, "SpotOnException should be caught");
        
        // Test throwing and catching APIException
        var caughtAPIException = false;
        try {
            throw new APIException(testMessage, testCode, testHttpStatus, testEndpoint, testDetails);
        } catch (e: APIException) {
            caughtAPIException = true;
            Assert.equals(testHttpStatus, e.httpStatus, "Caught APIException should have correct HTTP status");
            Assert.equals(testEndpoint, e.endpoint, "Caught APIException should have correct endpoint");
        } catch (e: SpotOnException) {
            Assert.fail("Should catch as APIException, not base SpotOnException");
        } catch (e: Dynamic) {
            Assert.fail("Should catch as APIException, not generic exception");
        }
        Assert.isTrue(caughtAPIException, "APIException should be caught");
    }
    
    /**
     * Test exception hierarchy catching
     */
    public function testExceptionHierarchyCatching() {
        // Test that APIException can be caught as SpotOnException
        var caughtAsBase = false;
        try {
            throw new APIException(testMessage, testCode, testHttpStatus, testEndpoint, testDetails);
        } catch (e: SpotOnException) {
            caughtAsBase = true;
            Assert.isTrue(Std.isOfType(e, APIException), "Exception should still be APIException instance");
            Assert.equals(testMessage, e.message, "Base exception properties should be accessible");
            Assert.equals(testCode, e.errorCode, "Base exception properties should be accessible");
        } catch (e: Dynamic) {
            Assert.fail("Should catch as SpotOnException");
        }
        Assert.isTrue(caughtAsBase, "APIException should be catchable as SpotOnException");
        
        // Test that AuthenticationException can be caught as SpotOnException
        var caughtAuthAsBase = false;
        try {
            throw new AuthenticationException(testMessage, testCode, testDetails);
        } catch (e: SpotOnException) {
            caughtAuthAsBase = true;
            Assert.isTrue(Std.isOfType(e, AuthenticationException), "Exception should still be AuthenticationException instance");
        } catch (e: Dynamic) {
            Assert.fail("Should catch as SpotOnException");
        }
        Assert.isTrue(caughtAuthAsBase, "AuthenticationException should be catchable as SpotOnException");
        
        // Test that NetworkException can be caught as SpotOnException
        var caughtNetworkAsBase = false;
        try {
            throw new NetworkException(testMessage, testCode, testDetails);
        } catch (e: SpotOnException) {
            caughtNetworkAsBase = true;
            Assert.isTrue(Std.isOfType(e, NetworkException), "Exception should still be NetworkException instance");
        } catch (e: Dynamic) {
            Assert.fail("Should catch as SpotOnException");
        }
        Assert.isTrue(caughtNetworkAsBase, "NetworkException should be catchable as SpotOnException");
    }
    
    /**
     * Test API-specific error scenarios
     */
    public function testAPISpecificErrorScenarios() {
        // Test 400 Bad Request
        var badRequestException = new APIException("Bad Request", "BAD_REQUEST", 400, "/api/v1/orders", {
            validationErrors: ["Missing required field: customer_id"]
        });
        Assert.equals(400, badRequestException.httpStatus, "Bad request should have 400 status");
        
        // Test 401 Unauthorized
        var unauthorizedException = new APIException("Unauthorized", "UNAUTHORIZED", 401, "/api/v1/orders", {
            reason: "Invalid API key"
        });
        Assert.equals(401, unauthorizedException.httpStatus, "Unauthorized should have 401 status");
        
        // Test 404 Not Found
        var notFoundException = new APIException("Not Found", "NOT_FOUND", 404, "/api/v1/orders/123", {
            resourceId: "123",
            resourceType: "order"
        });
        Assert.equals(404, notFoundException.httpStatus, "Not found should have 404 status");
        
        // Test 500 Internal Server Error
        var serverErrorException = new APIException("Internal Server Error", "INTERNAL_ERROR", 500, "/api/v1/orders", {
            requestId: "req_123456789"
        });
        Assert.equals(500, serverErrorException.httpStatus, "Server error should have 500 status");
    }
    
    /**
     * Test authentication-specific error scenarios
     */
    public function testAuthenticationSpecificErrorScenarios() {
        // Test invalid credentials
        var invalidCredsException = new AuthenticationException("Invalid credentials", "INVALID_CREDENTIALS", {
            attemptCount: 1,
            maxAttempts: 3
        });
        Assert.equals("INVALID_CREDENTIALS", invalidCredsException.errorCode, "Should have correct error code");
        
        // Test expired token
        var expiredTokenException = new AuthenticationException("Token expired", "TOKEN_EXPIRED", {
            expiredAt: 1234567890,
            tokenType: "bearer"
        });
        Assert.equals("TOKEN_EXPIRED", expiredTokenException.errorCode, "Should have correct error code");
        
        // Test insufficient permissions
        var insufficientPermsException = new AuthenticationException("Insufficient permissions", "INSUFFICIENT_PERMISSIONS", {
            requiredPermissions: ["orders:read", "orders:write"],
            userPermissions: ["orders:read"]
        });
        Assert.equals("INSUFFICIENT_PERMISSIONS", insufficientPermsException.errorCode, "Should have correct error code");
    }
    
    /**
     * Test network-specific error scenarios
     */
    public function testNetworkSpecificErrorScenarios() {
        // Test connection timeout
        var timeoutException = new NetworkException("Connection timeout", "CONNECTION_TIMEOUT", {
            timeoutMs: 30000,
            host: "api.spoton.com"
        });
        Assert.equals("CONNECTION_TIMEOUT", timeoutException.errorCode, "Should have correct error code");
        
        // Test DNS resolution failure
        var dnsException = new NetworkException("DNS resolution failed", "DNS_RESOLUTION_FAILED", {
            host: "invalid.spoton.com",
            dnsServer: "8.8.8.8"
        });
        Assert.equals("DNS_RESOLUTION_FAILED", dnsException.errorCode, "Should have correct error code");
        
        // Test connection refused
        var connectionRefusedException = new NetworkException("Connection refused", "CONNECTION_REFUSED", {
            host: "api.spoton.com",
            port: 443
        });
        Assert.equals("CONNECTION_REFUSED", connectionRefusedException.errorCode, "Should have correct error code");
    }
    
    /**
     * Test error propagation through SDK layers simulation
     */
    public function testErrorPropagationSimulation() {
        // Simulate error propagation from HTTP layer to endpoint layer
        var httpError = new APIException("HTTP request failed", "HTTP_REQUEST_FAILED", 500, "/api/v1/orders", {
            requestId: "req_123"
        });
        
        // Simulate catching and re-throwing with additional context
        var endpointError: SpotOnException = null;
        try {
            throw httpError;
        } catch (e: APIException) {
            // Endpoint layer catches and adds context
            endpointError = new SpotOnException("Order creation failed", "ORDER_CREATION_FAILED", {
                originalError: e,
                orderId: "order_456",
                customerInfo: { id: "cust_789" }
            });
        }
        
        Assert.notNull(endpointError, "Error should be propagated and wrapped");
        Assert.equals("ORDER_CREATION_FAILED", endpointError.errorCode, "Wrapped error should have new code");
        Assert.isTrue(Std.isOfType(endpointError.errorDetails.originalError, APIException), "Original error should be preserved");
        
        // Simulate client layer catching and handling
        var clientHandled = false;
        try {
            throw endpointError;
        } catch (e: SpotOnException) {
            clientHandled = true;
            Assert.equals("Order creation failed", e.message, "Client should receive wrapped error message");
            
            // Client can access original error details
            var originalError = e.errorDetails.originalError;
            Assert.isTrue(Std.isOfType(originalError, APIException), "Client can access original error");
            Assert.equals(500, cast(originalError, APIException).httpStatus, "Client can access original HTTP status");
        }
        Assert.isTrue(clientHandled, "Client should handle propagated error");
    }
    
    /**
     * Test error handling in various failure scenarios
     */
    public function testErrorHandlingFailureScenarios() {
        // Test handling of null values in exception creation
        var nullMessageException = new SpotOnException(null, testCode, testDetails);
        Assert.isNull(nullMessageException.message, "Null message should be handled gracefully");
        
        var nullCodeException = new SpotOnException(testMessage, null, testDetails);
        Assert.isNull(nullCodeException.errorCode, "Null code should be handled gracefully");
        
        // Test handling of extreme values
        var extremeHttpStatus = new APIException(testMessage, testCode, -1, testEndpoint, testDetails);
        Assert.equals(-1, extremeHttpStatus.httpStatus, "Extreme HTTP status should be preserved");
        
        var largeHttpStatus = new APIException(testMessage, testCode, 999, testEndpoint, testDetails);
        Assert.equals(999, largeHttpStatus.httpStatus, "Large HTTP status should be preserved");
        
        // Test handling of empty endpoint
        var emptyEndpointException = new APIException(testMessage, testCode, testHttpStatus, "", testDetails);
        Assert.equals("", emptyEndpointException.endpoint, "Empty endpoint should be preserved");
        
        // Test handling of null endpoint
        var nullEndpointException = new APIException(testMessage, testCode, testHttpStatus, null, testDetails);
        Assert.isNull(nullEndpointException.endpoint, "Null endpoint should be preserved");
    }
    
    /**
     * Test exception serialization and data integrity
     */
    public function testExceptionDataIntegrity() {
        var complexDetails = {
            nested: {
                level1: {
                    level2: {
                        value: "deep nested value"
                    }
                }
            },
            array: ([1, 2, 3, { key: "value" }] : Array<Dynamic>),
            nullValue: null,
            boolValue: false,
            numberValue: 3.14159
        };
        
        var exception = new SpotOnException(testMessage, testCode, complexDetails);
        
        // Verify all data is preserved
        Assert.equals(complexDetails.nested.level1.level2.value, exception.errorDetails.nested.level1.level2.value, "Deep nested values should be preserved");
        Assert.equals(4, exception.errorDetails.array.length, "Array length should be preserved");
        Assert.equals("value", exception.errorDetails.array[3].key, "Array object values should be preserved");
        Assert.isNull(exception.errorDetails.nullValue, "Null values should be preserved");
        Assert.equals(false, exception.errorDetails.boolValue, "Boolean values should be preserved");
        Assert.equals(3.14159, exception.errorDetails.numberValue, "Number values should be preserved");
    }
}