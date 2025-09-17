package spoton.http;

import haxe.Http;
import spoton.http.HTTPClient;
import spoton.http.Response;
import spoton.errors.SpotOnException;
import spoton.errors.AuthenticationException;
import spoton.errors.NetworkException;
import spoton.errors.APIException;
using StringTools;

/**
 * Concrete implementation of HTTPClient using haxe.Http
 * Provides cross-platform HTTP request functionality
 */
class HTTPClientImpl implements HTTPClient {
    private var baseUrl: String;
    private var defaultHeaders: Map<String, String>;
    
    /**
     * Constructor
     * @param baseUrl Base URL for all API requests
     */
    public function new(baseUrl: String) {
        this.baseUrl = baseUrl;
        this.defaultHeaders = new Map<String, String>();
        
        // Set default headers
        this.defaultHeaders.set("Content-Type", "application/json");
        this.defaultHeaders.set("Accept", "application/json");
    }
    
    /**
     * Set a default header for all requests
     * @param name Header name
     * @param value Header value
     */
    public function setDefaultHeader(name: String, value: String): Void {
        this.defaultHeaders.set(name, value);
    }
    
    /**
     * Perform a GET request
     * @param path The API endpoint path
     * @param params Optional query parameters
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    public function get(path: String, ?params: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        var url = buildUrl(path, params);
        makeRequest("GET", url, null, headers, callback);
    }
    
    /**
     * Perform a POST request
     * @param path The API endpoint path
     * @param data Optional request body data
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    public function post(path: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        var url = buildUrl(path);
        makeRequest("POST", url, data, headers, callback);
    }
    
    /**
     * Perform a PUT request
     * @param path The API endpoint path
     * @param data Optional request body data
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    public function put(path: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        var url = buildUrl(path);
        makeRequest("PUT", url, data, headers, callback);
    }
    
    /**
     * Perform a DELETE request
     * @param path The API endpoint path
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    public function delete(path: String, ?headers: Map<String, String>, callback: Response -> Void): Void {
        var url = buildUrl(path);
        makeRequest("DELETE", url, null, headers, callback);
    }
    
    /**
     * Internal method to make HTTP requests with comprehensive error handling
     * @param method HTTP method (GET, POST, PUT, DELETE)
     * @param url Complete URL for the request
     * @param data Optional request body data
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    private function makeRequest(method: String, url: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void {
        try {
            var http = new Http(url);
            var currentStatus: Int = 0;
            var responseHeaders = new Map<String, String>();
            
            // Set up header handler to capture response headers
            #if (js || nodejs)
            // For JavaScript/Node.js targets, we can access headers through the XMLHttpRequest
            http.onStatus = function(status: Int) {
                currentStatus = status;
                // Try to capture headers if available
                try {
                    var xhr = untyped http.req;
                    if (xhr != null && xhr.getAllResponseHeaders != null) {
                        var headerString = xhr.getAllResponseHeaders();
                        if (headerString != null) {
                            var headerLines = headerString.split('\r\n');
                            for (i in 0...headerLines.length) {
                                var line = headerLines[i];
                                var colonIndex = line.indexOf(':');
                                if (colonIndex > 0) {
                                    var name = StringTools.trim(line.substring(0, colonIndex));
                                    var value = StringTools.trim(line.substring(colonIndex + 1, line.length));
                                    responseHeaders.set(name, value);
                                }
                            }
                        }
                    }
                } catch (e: Dynamic) {
                    // Header capture failed, continue without headers
                }
            };
            #else
            // For other targets, just capture the status
            http.onStatus = function(status: Int) {
                currentStatus = status;
            };
            #end
            
            // Set default headers
            for (name in defaultHeaders.keys()) {
                http.setHeader(name, defaultHeaders.get(name));
            }
            
            // Set request-specific headers (these override default headers)
            if (headers != null) {
                for (name in headers.keys()) {
                    http.setHeader(name, headers.get(name));
                }
            }
            
            // Handle method-specific setup
            switch (method) {
                case "POST" | "PUT":
                    if (method == "PUT") {
                        http.setHeader("X-HTTP-Method-Override", "PUT");
                    }
                    if (data != null) {
                        var requestBody = haxe.Json.stringify(data);
                        http.setPostData(requestBody);
                    }
                case "DELETE":
                    http.setHeader("X-HTTP-Method-Override", "DELETE");
                case "GET":
                    // No special handling needed for GET
            }
            
            // Set up success handler
            http.onData = function(responseData: String) {
                try {
                    // If we didn't get a status from onStatus, assume 200 for successful data
                    if (currentStatus == 0) {
                        currentStatus = 200;
                    }
                    
                    // Parse JSON response data
                    var parsedData: Dynamic = null;
                    if (responseData != null && responseData.length > 0) {
                        try {
                            parsedData = haxe.Json.parse(responseData);
                        } catch (jsonError: Dynamic) {
                            // JSON parsing failed - this might be expected for non-JSON responses
                            // We'll set parsedData to null and include the raw body
                            parsedData = null;
                            
                            // Only throw an exception if we expected JSON (based on Content-Type)
                            var contentType = responseHeaders.get("Content-Type");
                            if (contentType != null && contentType.indexOf("application/json") >= 0) {
                                var networkException = new NetworkException(
                                    "Failed to parse JSON response: " + Std.string(jsonError),
                                    "JSON_PARSE_ERROR",
                                    { 
                                        originalError: jsonError, 
                                        url: url, 
                                        responseBody: responseData,
                                        contentType: contentType
                                    }
                                );
                                throw networkException;
                            }
                        }
                    }
                    
                    var response: Response = {
                        status: currentStatus,
                        headers: responseHeaders,
                        body: responseData,
                        data: parsedData,
                        success: (currentStatus >= 200 && currentStatus < 300)
                    };
                    
                    // Check for HTTP error status codes and throw appropriate exceptions
                    if (currentStatus >= 400) {
                        handleHttpError(currentStatus, url, responseData);
                        return;
                    }
                    
                    callback(response);
                } catch (e: SpotOnException) {
                    // Re-throw SpotOn exceptions as-is
                    throw e;
                } catch (e: Dynamic) {
                    // Handle other data processing errors
                    var networkException = new NetworkException(
                        "Failed to process response data: " + Std.string(e),
                        "RESPONSE_PROCESSING_ERROR",
                        { originalError: e, url: url }
                    );
                    throw networkException;
                }
            };
            
            // Set up error handler for network-level errors
            http.onError = function(error: String) {
                try {
                    // Network-level errors (connection failed, timeout, etc.)
                    var networkException = new NetworkException(
                        "Network request failed: " + error,
                        "NETWORK_ERROR",
                        { originalError: error, url: url, method: method }
                    );
                    throw networkException;
                } catch (e: Dynamic) {
                    // If we can't even create the exception, create a basic one
                    throw new NetworkException("Network request failed", "NETWORK_ERROR");
                }
            };
            
            // Make the request
            var isPost = (method == "POST" || method == "PUT" || method == "DELETE");
            http.request(isPost);
            
        } catch (e: SpotOnException) {
            // Re-throw SpotOn exceptions as-is
            throw e;
        } catch (e: Dynamic) {
            // Wrap any other exceptions as NetworkException
            var networkException = new NetworkException(
                "Unexpected error during HTTP request: " + Std.string(e),
                "UNEXPECTED_ERROR",
                { originalError: e, url: url, method: method }
            );
            throw networkException;
        }
    }
    
    /**
     * Handle HTTP error status codes by throwing appropriate exceptions
     * @param status HTTP status code
     * @param url Request URL
     * @param responseBody Response body (may contain error details)
     */
    private function handleHttpError(status: Int, url: String, responseBody: String): Void {
        var errorDetails: Dynamic = null;
        
        // Try to parse error details from response body using haxe.Json.parse
        try {
            if (responseBody != null && responseBody.length > 0) {
                errorDetails = haxe.Json.parse(responseBody);
            }
        } catch (jsonError: Dynamic) {
            // If JSON parsing fails, include raw response body and parsing error info
            errorDetails = { 
                rawResponse: responseBody,
                jsonParseError: Std.string(jsonError)
            };
        }
        
        // Throw appropriate exception based on status code
        switch (status) {
            case 401:
                throw new AuthenticationException(
                    "Authentication failed - invalid or missing credentials",
                    "AUTHENTICATION_FAILED",
                    errorDetails
                );
            case 403:
                throw new AuthenticationException(
                    "Access forbidden - insufficient permissions",
                    "ACCESS_FORBIDDEN", 
                    errorDetails
                );
            case 404:
                throw new APIException(
                    "Resource not found",
                    "RESOURCE_NOT_FOUND",
                    status,
                    url,
                    errorDetails
                );
            case 409:
                throw new APIException(
                    "Conflict - resource already exists or operation not allowed",
                    "CONFLICT",
                    status,
                    url,
                    errorDetails
                );
            case 422:
                throw new APIException(
                    "Validation failed - invalid request data",
                    "VALIDATION_ERROR",
                    status,
                    url,
                    errorDetails
                );
            case 429:
                throw new APIException(
                    "Rate limit exceeded - too many requests",
                    "RATE_LIMIT_EXCEEDED",
                    status,
                    url,
                    errorDetails
                );
            case 500:
                throw new APIException(
                    "Internal server error",
                    "INTERNAL_SERVER_ERROR",
                    status,
                    url,
                    errorDetails
                );
            case 502:
                throw new APIException(
                    "Bad gateway - upstream server error",
                    "BAD_GATEWAY",
                    status,
                    url,
                    errorDetails
                );
            case 503:
                throw new APIException(
                    "Service unavailable - server temporarily overloaded",
                    "SERVICE_UNAVAILABLE",
                    status,
                    url,
                    errorDetails
                );
            case 504:
                throw new APIException(
                    "Gateway timeout - upstream server timeout",
                    "GATEWAY_TIMEOUT",
                    status,
                    url,
                    errorDetails
                );
            default:
                if (status >= 400 && status < 500) {
                    // Client errors
                    throw new APIException(
                        "Client error: HTTP " + status,
                        "CLIENT_ERROR",
                        status,
                        url,
                        errorDetails
                    );
                } else if (status >= 500) {
                    // Server errors
                    throw new APIException(
                        "Server error: HTTP " + status,
                        "SERVER_ERROR",
                        status,
                        url,
                        errorDetails
                    );
                } else {
                    // Unexpected status code
                    throw new APIException(
                        "Unexpected HTTP status: " + status,
                        "UNEXPECTED_STATUS",
                        status,
                        url,
                        errorDetails
                    );
                }
        }
    }
    
    /**
     * Build the complete URL from base URL, path, and query parameters
     * @param path The API endpoint path
     * @param params Optional query parameters
     * @return Complete URL string
     */
    private function buildUrl(path: String, ?params: Dynamic): String {
        var url = baseUrl;
        
        // Ensure path starts with /
        if (!StringTools.startsWith(path, "/")) {
            url += "/";
        }
        url += path;
        
        // Add query parameters if provided
        if (params != null) {
            var queryString = buildQueryString(params);
            if (queryString.length > 0) {
                url += "?" + queryString;
            }
        }
        
        return url;
    }
    
    /**
     * Build query string from parameters object
     * @param params Parameters object
     * @return Query string
     */
    private function buildQueryString(params: Dynamic): String {
        var parts = new Array<String>();
        
        var fields = Reflect.fields(params);
        for (field in fields) {
            var value = Reflect.field(params, field);
            if (value != null) {
                parts.push(field + "=" + StringTools.urlEncode(Std.string(value)));
            }
        }
        
        return parts.join("&");
    }
}