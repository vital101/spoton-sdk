package test.spoton.endpoints;

import utest.Test;
import utest.Assert;
import spoton.endpoints.OrderEndpoint;
import spoton.errors.SpotOnException;
import test.spoton.http.MockHTTPClient;
import test.spoton.auth.MockAuthenticationManager;

/**
 * Test class for OrderEndpoint functionality
 * Tests order management functionality and parameter validation
 */
class OrderEndpointTest extends Test {
    
    private var mockHttpClient: MockHTTPClient;
    private var mockAuth: MockAuthenticationManager;
    private var orderEndpoint: OrderEndpoint;
    
    public function setup() {
        mockHttpClient = new MockHTTPClient();
        mockAuth = new MockAuthenticationManager();
        mockAuth.setAuthenticationState(true); // Set as authenticated
        orderEndpoint = new OrderEndpoint(mockHttpClient, mockAuth);
    }
    
    public function teardown() {
        mockHttpClient = null;
        mockAuth = null;
        orderEndpoint = null;
    }
    
    // Test submitOrder method
    
    public function testSubmitOrderSuccess() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        
        // Create test order data as Dynamic
        var testOrder: Dynamic = createTestOrder();
        
        // Configure mock response for successful order submission
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 201,
            headers: new Map<String, String>(),
            body: '{"id": "ORD-001", "state": "submitted", "location_id": "' + locationId + '", "customer": {"id": "CUST-123"}, "line_items": [{"id": "ITEM-001", "name": "Test Item", "quantity": 2, "price": 10.99}], "totals": {"total": 21.98, "tax": 1.76, "grand_total": 23.74}, "created_at": "2023-01-01T12:00:00Z"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var submittedOrder: Dynamic = null;
        
        orderEndpoint.submitOrder(locationId, testOrder, function(order: Dynamic) {
            callbackCalled = true;
            submittedOrder = order;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(submittedOrder);
        Assert.equals("ORD-001", submittedOrder.id);
        Assert.equals("submitted", submittedOrder.state);
        Assert.equals(locationId, submittedOrder.location_id);
        Assert.notNull(submittedOrder.customer);
        Assert.equals("CUST-123", submittedOrder.customer.id);
        Assert.notNull(submittedOrder.totals);
        Assert.equals(23.74, submittedOrder.totals.grand_total);
        
        // Verify correct HTTP request was made
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("POST", request.method);
        Assert.equals(expectedPath, request.path);
        Assert.notNull(request.data);
    }
    
    public function testSubmitOrderWithInvalidLocationId() {
        var testOrder: Dynamic = createTestOrder();
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder("", testOrder, function(order: Dynamic) {
                Assert.fail("Callback should not be called with invalid location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("MISSING_LOCATION_ID", e.errorCode);
            Assert.isTrue(e.message.indexOf("Location ID is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
        
        // Verify no HTTP request was made
        Assert.equals(0, mockHttpClient.requestHistory.length);
    }
    
    public function testSubmitOrderWithNullLocationId() {
        var testOrder: Dynamic = createTestOrder();
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder(null, testOrder, function(order: Dynamic) {
                Assert.fail("Callback should not be called with null location ID");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("MISSING_LOCATION_ID", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
        
        // Verify no HTTP request was made
        Assert.equals(0, mockHttpClient.requestHistory.length);
    }
    
    public function testSubmitOrderWithNullOrder() {
        var locationId = "BL-1234-5678-9012";
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder(locationId, null, function(order: Dynamic) {
                Assert.fail("Callback should not be called with null order");
            });
        } catch (e: SpotOnException) {
            exceptionThrown = true;
            Assert.equals("MISSING_ORDER_DATA", e.errorCode);
            Assert.isTrue(e.message.indexOf("Order data is required") >= 0);
        }
        
        Assert.isTrue(exceptionThrown);
        
        // Verify no HTTP request was made
        Assert.equals(0, mockHttpClient.requestHistory.length);
    }
    
    public function testSubmitOrderWithBadRequest() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        var testOrder: Dynamic = createTestOrder();
        
        // Configure mock response for bad request
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 400,
            headers: new Map<String, String>(),
            body: '{"error": "Invalid order data", "details": ["Missing required field: customer"]}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder(locationId, testOrder, function(order: Dynamic) {
                Assert.fail("Callback should not be called on bad request");
            });
        } catch (e: spoton.errors.APIException) {
            exceptionThrown = true;
            Assert.equals("BAD_REQUEST", e.errorCode);
            Assert.equals(400, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testSubmitOrderWithConflict() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        var testOrder: Dynamic = createTestOrder();
        
        // Configure mock response for conflict (duplicate order)
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 409,
            headers: new Map<String, String>(),
            body: '{"error": "Order already exists", "existingOrderId": "ORD-001"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder(locationId, testOrder, function(order: Dynamic) {
                Assert.fail("Callback should not be called on conflict");
            });
        } catch (e: spoton.errors.APIException) {
            exceptionThrown = true;
            Assert.equals("CONFLICT", e.errorCode);
            Assert.equals(409, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testSubmitOrderWithRateLimit() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        var testOrder: Dynamic = createTestOrder();
        
        // Configure mock response for rate limit exceeded
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 429,
            headers: new Map<String, String>(),
            body: '{"error": "Rate limit exceeded", "retryAfter": 60}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder(locationId, testOrder, function(order: Dynamic) {
                Assert.fail("Callback should not be called on rate limit");
            });
        } catch (e: spoton.errors.APIException) {
            exceptionThrown = true;
            Assert.equals("RATE_LIMIT_EXCEEDED", e.errorCode);
            Assert.equals(429, e.httpStatus);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    // Test parameter validation and response mapping
    
    public function testOrderParameterValidation() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        
        // Create order with missing required fields
        var invalidOrder: Dynamic = {
            id: null,
            external_reference_id: "EXT-001",
            location_id: locationId,
            line_items: [], // Empty items array
            state: null,
            source: null,
            customer: null, // Missing required field
            fulfillment: null,
            totals: null,
            menu_id: null
        };
        
        // Configure mock response for validation error
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 400,
            headers: new Map<String, String>(),
            body: '{"error": "Validation failed", "details": ["customer is required", "line_items cannot be empty"]}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var exceptionThrown = false;
        try {
            orderEndpoint.submitOrder(locationId, invalidOrder, function(order: Dynamic) {
                Assert.fail("Callback should not be called with invalid order");
            });
        } catch (e: spoton.errors.APIException) {
            exceptionThrown = true;
            Assert.equals("BAD_REQUEST", e.errorCode);
        }
        
        Assert.isTrue(exceptionThrown);
    }
    
    public function testOrderResponseMapping() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        var testOrder: Dynamic = createTestOrder();
        
        // Configure mock response with complete order data
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 201,
            headers: new Map<String, String>(),
            body: '{"id": "ORD-002", "state": "submitted", "location_id": "' + locationId + '", "external_reference_id": "EXT-002", "customer": {"id": "CUST-456", "name": "John Doe"}, "line_items": [{"id": "ITEM-002", "name": "Premium Item", "quantity": 1, "price": 25.99}, {"id": "ITEM-003", "name": "Side Item", "quantity": 2, "price": 5.99}], "totals": {"subtotal": 37.97, "tax": 3.04, "tip": 5.00, "grand_total": 45.01}, "created_at": "2023-01-01T14:30:00Z", "fulfillment": {"type": "pickup", "estimated_ready_time": "2023-01-01T15:00:00Z"}, "source": {"channel": "online", "platform": "web"}, "menu_id": "MENU-001"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var submittedOrder: Dynamic = null;
        
        orderEndpoint.submitOrder(locationId, testOrder, function(order: Dynamic) {
            callbackCalled = true;
            submittedOrder = order;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(submittedOrder);
        Assert.equals("ORD-002", submittedOrder.id);
        Assert.equals("submitted", submittedOrder.state);
        Assert.equals(locationId, submittedOrder.location_id);
        Assert.equals("EXT-002", submittedOrder.external_reference_id);
        Assert.equals("MENU-001", submittedOrder.menu_id);
        
        // Test customer object
        Assert.notNull(submittedOrder.customer);
        Assert.equals("CUST-456", submittedOrder.customer.id);
        Assert.equals("John Doe", submittedOrder.customer.name);
        
        // Test totals object
        Assert.notNull(submittedOrder.totals);
        Assert.equals(37.97, submittedOrder.totals.subtotal);
        Assert.equals(3.04, submittedOrder.totals.tax);
        Assert.equals(5.00, submittedOrder.totals.tip);
        Assert.equals(45.01, submittedOrder.totals.grand_total);
        
        // Test line_items array
        Assert.notNull(submittedOrder.line_items);
        Assert.equals(2, submittedOrder.line_items.length);
        
        var firstItem = submittedOrder.line_items[0];
        Assert.equals("ITEM-002", firstItem.id);
        Assert.equals("Premium Item", firstItem.name);
        Assert.equals(1, firstItem.quantity);
        Assert.equals(25.99, firstItem.price);
        
        var secondItem = submittedOrder.line_items[1];
        Assert.equals("ITEM-003", secondItem.id);
        Assert.equals("Side Item", secondItem.name);
        Assert.equals(2, secondItem.quantity);
        Assert.equals(5.99, secondItem.price);
        
        // Test fulfillment object
        Assert.notNull(submittedOrder.fulfillment);
        Assert.equals("pickup", submittedOrder.fulfillment.type);
        Assert.equals("2023-01-01T15:00:00Z", submittedOrder.fulfillment.estimated_ready_time);
        
        // Test source object
        Assert.notNull(submittedOrder.source);
        Assert.equals("online", submittedOrder.source.channel);
        Assert.equals("web", submittedOrder.source.platform);
    }
    
    public function testOrderSubmissionWithComplexData() {
        var locationId = "BL-1234-5678-9012";
        var expectedPath = '/order/v1/locations/${locationId}/orders';
        
        // Create complex order with multiple items
        var complexOrder: Dynamic = createComplexTestOrder();
        
        // Configure mock response
        mockHttpClient.setMockResponse("POST", expectedPath, {
            statusCode: 201,
            headers: new Map<String, String>(),
            body: '{"id": "ORD-003", "state": "submitted", "location_id": "' + locationId + '", "external_reference_id": "EXT-003", "customer": {"id": "CUST-789"}, "line_items": [{"id": "ITEM-004", "name": "Complex Item", "quantity": 3, "price": 15.99}], "totals": {"subtotal": 47.97, "tax": 3.84, "grand_total": 51.81}, "created_at": "2023-01-01T16:00:00Z", "menu_id": "MENU-002"}',
            delay: 0,
            shouldFail: false,
            errorType: ""
        });
        
        var callbackCalled = false;
        var submittedOrder: Dynamic = null;
        
        orderEndpoint.submitOrder(locationId, complexOrder, function(order: Dynamic) {
            callbackCalled = true;
            submittedOrder = order;
        });
        
        Assert.isTrue(callbackCalled);
        Assert.notNull(submittedOrder);
        Assert.equals("ORD-003", submittedOrder.id);
        Assert.equals("CUST-789", submittedOrder.customer.id);
        Assert.equals(51.81, submittedOrder.totals.grand_total);
        
        // Verify the request data was sent correctly
        Assert.equals(1, mockHttpClient.requestHistory.length);
        var request = mockHttpClient.requestHistory[0];
        Assert.equals("POST", request.method);
        Assert.equals(expectedPath, request.path);
        Assert.notNull(request.data);
        
        // Verify request data structure
        var sentOrder: Dynamic = request.data;
        Assert.equals("CUST-789", sentOrder.customer.id);
        Assert.notNull(sentOrder.line_items);
        Assert.isTrue(sentOrder.line_items.length > 0);
    }
    
    // Helper methods for creating test data
    
    private function createTestOrder(): Dynamic {
        return {
            id: null,
            external_reference_id: "EXT-TEST-001",
            location_id: null,
            line_items: [
                {
                    id: "ITEM-001",
                    name: "Test Item",
                    quantity: 2,
                    price: 10.99
                }
            ],
            state: null,
            source: {
                channel: "online",
                platform: "test"
            },
            customer: {
                id: "CUST-123",
                name: "Test Customer"
            },
            fulfillment: {
                type: "pickup"
            },
            totals: {
                subtotal: 21.98,
                tax: 1.76,
                grand_total: 23.74
            },
            menu_id: "MENU-001"
        };
    }
    
    private function createComplexTestOrder(): Dynamic {
        return {
            id: null,
            external_reference_id: "EXT-COMPLEX-001",
            location_id: null,
            line_items: [
                {
                    id: "ITEM-004",
                    name: "Complex Item",
                    quantity: 3,
                    price: 15.99
                },
                {
                    id: "ITEM-005",
                    name: "Another Item",
                    quantity: 1,
                    price: 8.50
                }
            ],
            state: null,
            source: {
                channel: "mobile",
                platform: "app"
            },
            customer: {
                id: "CUST-789",
                name: "Complex Customer",
                email: "complex@example.com"
            },
            fulfillment: {
                type: "delivery",
                address: "123 Test St"
            },
            totals: {
                subtotal: 56.47,
                tax: 4.52,
                grand_total: 60.99
            },
            menu_id: "MENU-002"
        };
    }
}