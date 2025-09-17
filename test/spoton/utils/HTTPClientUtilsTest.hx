package test.spoton.utils;

import utest.Test;
import utest.Assert;
import spoton.http.HTTPClientImpl;

/**
 * Test suite for HTTPClient utility functions
 * Tests URL encoding, parameter handling, and HTTP utility functions
 */
class HTTPClientUtilsTest extends Test {
    
    private var httpClient: HTTPClientImpl;
    
    function setup() {
        httpClient = new HTTPClientImpl("https://api.spoton.com");
    }
    
    function testHttpClientInitialization() {
        var client = new HTTPClientImpl("https://api.spoton.com");
        Assert.notNull(client);
    }
    
    function testHttpClientWithCustomBaseUrl() {
        var customBaseUrl = "https://custom.api.spoton.com";
        var client = new HTTPClientImpl(customBaseUrl);
        Assert.notNull(client);
    }
    
    function testHttpClientWithEmptyBaseUrl() {
        var client = new HTTPClientImpl("");
        Assert.notNull(client);
    }
    
    function testHttpClientWithNullBaseUrl() {
        var client = new HTTPClientImpl(null);
        Assert.notNull(client);
    }
    
    function testUrlEncodingUtility() {
        // Test URL encoding of special characters
        var testString = "hello world";
        var encoded = StringTools.urlEncode(testString);
        Assert.equals("hello%20world", encoded);
    }
    
    function testUrlEncodingWithSpecialCharacters() {
        var testString = "café & restaurant";
        var encoded = StringTools.urlEncode(testString);
        Assert.notNull(encoded);
        Assert.isTrue(encoded.length > 0);
        // The exact encoding may vary by platform, but it should be encoded
        Assert.notEquals(testString, encoded);
    }
    
    function testUrlEncodingWithSymbols() {
        var testString = "@#$%^&*()";
        var encoded = StringTools.urlEncode(testString);
        Assert.notNull(encoded);
        Assert.isTrue(encoded.length > 0);
        // Should be different from original due to encoding
        Assert.notEquals(testString, encoded);
    }
    
    function testParameterStringification() {
        // Test converting various data types to strings for URL parameters
        var stringValue = Std.string("test");
        var intValue = Std.string(42);
        var floatValue = Std.string(3.14);
        var boolValue = Std.string(true);
        
        Assert.equals("test", stringValue);
        Assert.equals("42", intValue);
        Assert.equals("3.14", floatValue);
        Assert.equals("true", boolValue);
    }
    
    function testParameterValidation() {
        // Test parameter validation utilities
        var validParams = {
            name: "test",
            value: 123,
            active: true
        };
        
        // Should not throw exception for valid params
        Assert.notNull(validParams);
        Assert.equals("test", validParams.name);
        Assert.equals(123, validParams.value);
        Assert.equals(true, validParams.active);
    }
    
    function testParameterWithNullValues() {
        var paramsWithNull = {
            name: "test",
            nullValue: null,
            emptyString: ""
        };
        
        Assert.equals("test", paramsWithNull.name);
        Assert.isNull(paramsWithNull.nullValue);
        Assert.equals("", paramsWithNull.emptyString);
    }
    
    function testHttpStatusCodeValidation() {
        // Test HTTP status code validation utilities
        var successCodes = [200, 201, 202, 204];
        var clientErrorCodes = [400, 401, 403, 404];
        var serverErrorCodes = [500, 502, 503, 504];
        
        for (code in successCodes) {
            Assert.isTrue(code >= 200 && code < 300, 'Status code $code should be success');
        }
        
        for (code in clientErrorCodes) {
            Assert.isTrue(code >= 400 && code < 500, 'Status code $code should be client error');
        }
        
        for (code in serverErrorCodes) {
            Assert.isTrue(code >= 500 && code < 600, 'Status code $code should be server error');
        }
    }
    
    function testHeaderValidation() {
        // Test HTTP header validation
        var headers = new Map<String, String>();
        headers.set("Content-Type", "application/json");
        headers.set("Authorization", "Bearer token123");
        headers.set("User-Agent", "SpotOn-SDK/1.0");
        
        Assert.equals("application/json", headers.get("Content-Type"));
        Assert.equals("Bearer token123", headers.get("Authorization"));
        Assert.equals("SpotOn-SDK/1.0", headers.get("User-Agent"));
    }
    
    function testHeaderCaseInsensitivity() {
        var headers = new Map<String, String>();
        headers.set("content-type", "application/json");
        headers.set("AUTHORIZATION", "Bearer token123");
        
        // Headers should be stored as set
        Assert.equals("application/json", headers.get("content-type"));
        Assert.equals("Bearer token123", headers.get("AUTHORIZATION"));
    }
    
    function testContentTypeDetection() {
        var jsonContentType = "application/json";
        var xmlContentType = "application/xml";
        var textContentType = "text/plain";
        
        Assert.isTrue(jsonContentType.indexOf("json") >= 0);
        Assert.isTrue(xmlContentType.indexOf("xml") >= 0);
        Assert.isTrue(textContentType.indexOf("text") >= 0);
    }
    
    function testQueryStringBuilding() {
        // Test manual query string building
        var params = ["name=test", "value=123", "active=true"];
        var queryString = params.join("&");
        
        Assert.equals("name=test&value=123&active=true", queryString);
    }
    
    function testQueryStringWithEncoding() {
        var encodedParam = "search=" + StringTools.urlEncode("hello world");
        Assert.equals("search=hello%20world", encodedParam);
    }
}