package test.spoton.utils;

import utest.Test;
import utest.Assert;
import haxe.Json;

/**
 * Test suite for data transformation and validation utilities
 * Tests JSON handling, data conversion, and validation helper functions
 */
class DataTransformationUtilsTest extends Test {
    
    function testJsonStringifyWithSimpleObject() {
        var data = {
            id: "123",
            name: "Test Item",
            price: 12.99,
            active: true
        };
        
        var jsonString = Json.stringify(data);
        Assert.notNull(jsonString);
        Assert.isTrue(jsonString.length > 0);
        
        // Should be valid JSON
        var parsed = Json.parse(jsonString);
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
        
        var jsonString = Json.stringify(data);
        Assert.notNull(jsonString);
        
        // Should be valid JSON that can be parsed back
        var parsed = Json.parse(jsonString);
        Assert.equals("order_123", parsed.order.id);
        Assert.equals(2, parsed.order.items.length);
        Assert.equals("Burger", parsed.order.items[0].name);
        Assert.equals("John Doe", parsed.order.customer.name);
        Assert.equals(2, parsed.order.customer.preferences.length);
    }
    
    function testJsonStringifyWithNullValues() {
        var data = {
            id: "123",
            name: null,
            description: "",
            active: true
        };
        
        var jsonString = Json.stringify(data);
        Assert.notNull(jsonString);
        
        var parsed = Json.parse(jsonString);
        Assert.equals("123", parsed.id);
        Assert.isNull(parsed.name);
        Assert.equals("", parsed.description);
        Assert.equals(true, parsed.active);
    }
    
    function testJsonStringifyWithSpecialCharacters() {
        var data = {
            message: "Hello, world! Special chars: àáâãäåæçèéêë",
            symbols: "@#$%^&*()",
            quotes: 'He said "Hello" to me',
            newlines: "Line 1\nLine 2\nLine 3"
        };
        
        var jsonString = Json.stringify(data);
        Assert.notNull(jsonString);
        
        var parsed = Json.parse(jsonString);
        Assert.equals("Hello, world! Special chars: àáâãäåæçèéêë", parsed.message);
        Assert.equals("@#$%^&*()", parsed.symbols);
        Assert.equals('He said "Hello" to me', parsed.quotes);
        Assert.equals("Line 1\nLine 2\nLine 3", parsed.newlines);
    }
    
    function testJsonParseWithValidJson() {
        var jsonString = '{"id": "123", "name": "Test Item", "price": 12.99, "active": true}';
        
        var parsed = Json.parse(jsonString);
        Assert.notNull(parsed);
        Assert.equals("123", parsed.id);
        Assert.equals("Test Item", parsed.name);
        Assert.equals(12.99, parsed.price);
        Assert.equals(true, parsed.active);
    }
    
    function testJsonParseWithComplexJson() {
        var jsonString = '{"items": [{"id": "1", "nested": {"value": true}}, {"id": "2", "nested": {"value": false}}], "meta": {"total": 2}}';
        
        var parsed = Json.parse(jsonString);
        Assert.notNull(parsed);
        Assert.equals(2, parsed.items.length);
        Assert.equals("1", parsed.items[0].id);
        Assert.isTrue(parsed.items[0].nested.value);
        Assert.equals("2", parsed.items[1].id);
        Assert.isFalse(parsed.items[1].nested.value);
        Assert.equals(2, parsed.meta.total);
    }
    
    function testJsonParseWithInvalidJson() {
        var invalidJsonString = '{"id": "123", "name": "Test Item", "price":}'; // Missing value
        
        Assert.raises(function() {
            Json.parse(invalidJsonString);
        });
    }
    
    function testJsonParseWithMalformedJson() {
        var malformedJsonString = 'not json at all';
        
        Assert.raises(function() {
            Json.parse(malformedJsonString);
        });
    }
    
    function testJsonParseWithEmptyString() {
        Assert.raises(function() {
            Json.parse("");
        });
    }
    
    function testJsonParseWithNullString() {
        Assert.raises(function() {
            Json.parse(null);
        });
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
        var jsonString = Json.stringify(originalData);
        var parsedData = Json.parse(jsonString);
        
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
    
    function testDataTypeValidation() {
        var testData = {
            stringValue: "test",
            intValue: 42,
            floatValue: 3.14,
            boolValue: true,
            nullValue: null,
            arrayValue: [1, 2, 3],
            objectValue: { nested: "value" }
        };
        
        var jsonString = Json.stringify(testData);
        var parsed = Json.parse(jsonString);
        
        // Verify types are preserved correctly
        Assert.isTrue(Std.isOfType(parsed.stringValue, String));
        Assert.isTrue(Std.isOfType(parsed.intValue, Int) || Std.isOfType(parsed.intValue, Float));
        Assert.isTrue(Std.isOfType(parsed.floatValue, Float));
        Assert.isTrue(Std.isOfType(parsed.boolValue, Bool));
        Assert.isNull(parsed.nullValue);
        Assert.isTrue(Std.isOfType(parsed.arrayValue, Array));
        Assert.notNull(parsed.objectValue);
    }
    
    function testLargeDataHandling() {
        // Create a large data structure
        var largeArray = [];
        for (i in 0...1000) {
            largeArray.push({
                id: "item_" + i,
                name: "Item " + i,
                value: i * 1.5,
                active: (i % 2 == 0),
                tags: ["tag" + (i % 10), "category" + (i % 5)]
            });
        }
        
        var largeData = {
            items: largeArray,
            metadata: {
                total: largeArray.length,
                generated: "2023-01-01T00:00:00Z"
            }
        };
        
        // Should handle large data without issues
        var jsonString = Json.stringify(largeData);
        Assert.notNull(jsonString);
        Assert.isTrue(jsonString.length > 0);
        
        var parsed = Json.parse(jsonString);
        Assert.equals(1000, parsed.items.length);
        Assert.equals(1000, parsed.metadata.total);
        Assert.equals("item_999", parsed.items[999].id);
    }
    
    function testEdgeCaseValues() {
        var edgeCaseData = {
            emptyString: "",
            zeroNumber: 0,
            negativeNumber: -42,
            veryLargeNumber: 999999999999,
            verySmallNumber: 0.000001,
            emptyArray: [],
            emptyObject: {},
            unicodeString: "🚀 Unicode test 中文 العربية"
        };
        
        var jsonString = Json.stringify(edgeCaseData);
        var parsed = Json.parse(jsonString);
        
        Assert.equals("", parsed.emptyString);
        Assert.equals(0, parsed.zeroNumber);
        Assert.equals(-42, parsed.negativeNumber);
        Assert.equals(999999999999, parsed.veryLargeNumber);
        Assert.equals(0.000001, parsed.verySmallNumber);
        Assert.equals(0, parsed.emptyArray.length);
        Assert.notNull(parsed.emptyObject);
        Assert.equals("🚀 Unicode test 中文 العربية", parsed.unicodeString);
    }
}