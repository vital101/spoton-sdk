package test.spoton.utils;

import utest.Test;
import utest.Assert;
import spoton.endpoints.BaseEndpoint;
import spoton.http.Response;
import spoton.errors.SpotOnException;
import test.spoton.auth.MockAuthenticationManager;
import test.spoton.http.MockHTTPClient;

/**
 * Test suite for BaseEndpoint utility functions
 * Tests JSON parsing, parameter validation, and error handling utilities
 */
class BaseEndpointUtilsTest extends Test {
    
    private var endpoint: BaseEndpoint;
    private var mockHttpClient: MockHTTPClient;
    private var mockAuth: MockAuthenticationManager;
    
    function setup() {
        mockHttpClient = new MockHTTPClient();
        mockAuth = new MockAuthenticationManager();
        endpoint = new BaseEndpoint(mockHttpClient, mockAuth);
    }
    
    function testJsonParsingWithValidJson() {
        var jsonBody = '{"id": "123", "name": "Test Item", "price": 1299}';
        
        var parsed = haxe.Json.parse(jsonBody);
        Assert.notNull(parsed);
        Assert.equals("123", parsed.id);
        Assert.equals("Test Item", parsed.name);
        Assert.equals(1299, parsed.price);
    }
    
    function testJsonParsingWithComplexJson() {
        var complexJsonBody = '{"items": [{"id": "1", "nested": {"value": true}}, {"id": "2", "nested": {"value": false}}], "meta": {"total": 2}}';
        
        var parsed = haxe.Json.parse(complexJsonBody);
        Assert.notNull(parsed);
        Assert.equals(2, parsed.items.length);
        Assert.equals("1", parsed.items[0].id);
        Assert.isTrue(parsed.items[0].nested.value);
        Assert.equals("2", parsed.items[1].id);
        Assert.isFalse(parsed.items[1].nested.value);
        Assert.equals(2, parsed.meta.total);
    }
    
    function testJsonParsingWithSpecialCharacters() {
        var jsonWithSpecialChars = '{"message": "Hello, world! Special chars: àáâãäåæçèéêë", "symbols": "@#$%^&*()"}';
        
        var parsed = haxe.Json.parse(jsonWithSpecialChars);
        Assert.notNull(parsed);
        Assert.equals("Hello, world! Special chars: àáâãäåæçèéêë", parsed.message);
        Assert.equals("@#$%^&*()", parsed.symbols);
    }
    
    function testJsonParsingWithInvalidJson() {
        var invalidJsonBody = '{"id": "123", "name": "Test Item", "price":}'; // Missing value
        
        Assert.raises(function() {
            haxe.Json.parse(invalidJsonBody);
        });
    }
    
    function testJsonParsingWithMalformedJson() {
        var malformedJsonBody = 'not json at all';
        
        Assert.raises(function() {
            haxe.Json.parse(malformedJsonBody);
        });
    }
    
    function testValidateParamsWithNull() {
        // Should not throw exception
        endpoint.validateParams(null);
        Assert.pass();
    }
    
    function testValidateParamsWithValidObject() {
        var params = {
            id: "123",
            name: "Test",
            active: true
        };
        
        // Should not throw exception
        endpoint.validateParams(params);
        Assert.pass();
    }
    
    function testValidateParamsWithEmptyObject() {
        var params = {};
        
        // Should not throw exception
        endpoint.validateParams(params);
        Assert.pass();
    }
    
    function testValidateParamsWithComplexObject() {
        var params = {
            user: {
                id: "user_123",
                profile: {
                    name: "John Doe",
                    preferences: ["pref1", "pref2"]
                }
            },
            settings: {
                notifications: true,
                theme: "dark"
            }
        };
        
        // Should not throw exception
        endpoint.validateParams(params);
        Assert.pass();
    }
    
    function testJsonStringifyWithSimpleObject() {
        var data = {
            id: "123",
            name: "Test Item",
            price: 12.99,
            active: true
        };
        
        var jsonString = haxe.Json.stringify(data);
        Assert.notNull(jsonString);
        Assert.isTrue(jsonString.length > 0);
        
        // Should be valid JSON
        var parsed = haxe.Json.parse(jsonString);
        Assert.equals("123", parsed.id);
        Assert.equals("Test Item", parsed.name);
        Assert.equals(12.99, parsed.price);
        Assert.equals(true, parsed.active);
    }
    
    function testJsonStringifyWithComplexObject() {
        var data = {
            order: {
                id: "order_123",
                items: [
                    { name: "Burger", price: 12.99 },
                    { name: "Fries", price: 4.99 }
                ],
                customer: {
                    id: "customer_456",
                    name: "John Doe",
                    preferences: ["no-onions", "extra-cheese"]
                }
            },
            meta: {
                timestamp: "2023-01-01T12:00:00Z",
                version: 1
            }
        };
        
        var jsonString = haxe.Json.stringify(data);
        Assert.notNull(jsonString);
        
        // Should be valid JSON that can be parsed back
        var parsed = haxe.Json.parse(jsonString);
        Assert.equals("order_123", parsed.order.id);
        Assert.equals(2, parsed.order.items.length);
        Assert.equals("Burger", parsed.order.items[0].name);
        Assert.equals("John Doe", parsed.order.customer.name);
        Assert.equals(2, parsed.order.customer.preferences.length);
    }
    
    function testJsonRoundTripConsistency() {
        var originalData = {
            id: "test_123",
            items: [
                { name: "Item 1", price: 10.50, tags: ["tag1", "tag2"] },
                { name: "Item 2", price: 15.75, tags: ["tag3"] }
            ],
            metadata: {
                created: "2023-01-01T00:00:00Z",
                updated: "2023-01-02T00:00:00Z",
                version: 2
            },
            flags: {
                active: true,
                featured: false,
                deleted: null
            }
        };
        
        // Convert to JSON and back
        var jsonString = haxe.Json.stringify(originalData);
        var parsedData = haxe.Json.parse(jsonString);
        
        // Verify data integrity
        Assert.equals(originalData.id, parsedData.id);
        Assert.equals(originalData.items.length, parsedData.items.length);
        Assert.equals(originalData.items[0].name, parsedData.items[0].name);
        Assert.equals(originalData.items[0].price, parsedData.items[0].price);
        Assert.equals(originalData.items[0].tags.length, parsedData.items[0].tags.length);
        Assert.equals(originalData.metadata.version, parsedData.metadata.version);
        Assert.equals(originalData.flags.active, parsedData.flags.active);
        Assert.equals(originalData.flags.featured, parsedData.flags.featured);
        Assert.isNull(parsedData.flags.deleted);
    }
}