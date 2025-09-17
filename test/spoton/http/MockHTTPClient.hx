package test.spoton.http;

import spoton.http.HTTPClient;
import spoton.http.Response;

/**
 * Mock HTTP client for testing purposes
 * Provides configurable responses and request history tracking
 */
class MockHTTPClient implements HTTPClient {
    
    /**
     * Mock response configuration
     */
    public var mockResponses: Map<String, MockResponse>;
    
    /**
     * Default headers for all requests
     */
    public var defaultHeaders: Map<String, String>;
    
    /**
     * History of all requests made
     */
    public var requestHistory: Array<RequestRecord>;
    
    /**
     * Global delay for all responses (milliseconds)
     */
    public var globalDelay: Int = 0;
    
    /**
     * Whether to simulate network errors
     */
    public var simulateNetworkError: Bool = false;
    
    /**
     * Network error message to use
     */
    public var networkErrorMessage: String = "Network error";
    
    public function new() {
        mockResponses = new Map<String, MockResponse>();
        defaultHeaders = new Map<String, String>();
        requestHistory = new Array<RequestRecord>();
    }
    
    /**
     * Configure a mock response for a specific path and method
     */
    public function setMockResponse(method: String, path: String, response: MockResponse): Void {
        var key = method.toUpperCase() + ":" + path;
        mockResponses.set(key, response);
    }
    
    /**
     * Clear all mock responses
     */
    public function clearMockResponses(): Void {
        mockResponses.clear();
    }
    
    /**
     * Clear request history
     */
    public function clearRequestHistory(): Void {
        requestHistory = new Array<RequestRecord>();
    }
    
    /**
     * Get the last request made
     */
    public function getLastRequest(): RequestRecord {
        return requestHistory.length > 0 ? requestHistory[requestHistory.length - 1] : null;
    }
    
    /**
     * Get all requests for a specific method and path
     */
    public function getRequestsFor(method: String, path: String): Array<RequestRecord> {
        return requestHistory.filter(function(record) {
            return record.method == method.toUpperCase() && record.path == path;
        });
    }
    
    public function setDefaultHeader(name: String, value: String): Void {
        defaultHeaders.set(name, value);
    }
    
    public function get(path: String, ?params: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        makeRequest("GET", path, null, params, headers, callback);
    }
    
    public function post(path: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        makeRequest("POST", path, data, null, headers, callback);
    }
    
    public function put(path: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        makeRequest("PUT", path, data, null, headers, callback);
    }
    
    public function delete(path: String, ?headers: Map<String, String>, callback: Response -> Void): Void {
        makeRequest("DELETE", path, null, null, headers, callback);
    }
    
    private function makeRequest(method: String, path: String, ?data: Dynamic, ?params: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        // Record the request
        var record: RequestRecord = {
            method: method,
            path: path,
            data: data,
            params: params,
            headers: mergeHeaders(headers),
            timestamp: Date.now().getTime()
        };
        requestHistory.push(record);
        
        // Simulate network error if configured
        if (simulateNetworkError) {
            var errorResponse: Response = {
                status: 0,
                headers: new Map<String, String>(),
                body: networkErrorMessage,
                data: null,
                success: false
            };
            
            if (globalDelay > 0) {
                haxe.Timer.delay(function() {
                    callback(errorResponse);
                }, globalDelay);
            } else {
                callback(errorResponse);
            }
            return;
        }
        
        // Find mock response
        var key = method + ":" + path;
        var mockResponse = mockResponses.get(key);
        
        if (mockResponse == null) {
            // Default 404 response if no mock configured
            mockResponse = {
                statusCode: 404,
                headers: new Map<String, String>(),
                body: '{"error": "Not Found"}',
                delay: 0,
                shouldFail: false,
                errorType: null
            };
        }
        
        // Create response
        var response: Response = {
            status: mockResponse.statusCode,
            headers: mockResponse.headers,
            body: mockResponse.body,
            data: parseJsonSafely(mockResponse.body),
            success: mockResponse.statusCode >= 200 && mockResponse.statusCode < 300
        };
        
        // Apply delay
        var totalDelay = globalDelay + mockResponse.delay;
        if (totalDelay > 0) {
            haxe.Timer.delay(function() {
                callback(response);
            }, totalDelay);
        } else {
            callback(response);
        }
    }
    
    private function mergeHeaders(?requestHeaders: Map<String, String>): Map<String, String> {
        var merged = new Map<String, String>();
        
        // Add default headers
        for (key in defaultHeaders.keys()) {
            merged.set(key, defaultHeaders.get(key));
        }
        
        // Add request-specific headers (override defaults)
        if (requestHeaders != null) {
            for (key in requestHeaders.keys()) {
                merged.set(key, requestHeaders.get(key));
            }
        }
        
        return merged;
    }
    
    private function parseJsonSafely(body: String): Dynamic {
        try {
            return haxe.Json.parse(body);
        } catch (e: Dynamic) {
            return null;
        }
    }
}

/**
 * Mock response configuration
 */
typedef MockResponse = {
    statusCode: Int,
    headers: Map<String, String>,
    body: String,
    delay: Int, // milliseconds
    shouldFail: Bool,
    errorType: String
}

/**
 * Request record for history tracking
 */
typedef RequestRecord = {
    method: String,
    path: String,
    data: Dynamic,
    params: Dynamic,
    headers: Map<String, String>,
    timestamp: Float
}