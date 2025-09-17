package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.http.Response;
import spoton.auth.AuthenticationManager;
import spoton.errors.SpotOnException;
import spoton.errors.APIException;
import spoton.errors.NetworkException;
import spoton.errors.AuthenticationException;

/**
 * Abstract base class for all API endpoint implementations.
 * Provides common functionality for making authenticated HTTP requests,
 * handling errors, and parsing responses.
 */
class BaseEndpoint {
    /**
     * HTTP client for making requests
     */
    private var httpClient: HTTPClient;
    
    /**
     * Authentication manager for handling auth headers
     */
    private var auth: AuthenticationManager;
    
    /**
     * Creates a new BaseEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        this.httpClient = httpClient;
        this.auth = auth;
    }
    
    /**
     * Makes an authenticated HTTP request to the specified endpoint
     * NOTE: This method is intended for use by subclasses only
     * @param method HTTP method (GET, POST, PUT, DELETE)
     * @param path API endpoint path
     * @param data Optional request body data (for POST/PUT requests)
     * @param callback Callback function to handle the parsed response
     */
    public function makeRequest(method: String, path: String, ?data: Dynamic, callback: Dynamic -> Void): Void {
        makeRequestWithHeaders(method, path, data, null, callback);
    }
    
    /**
     * Makes an authenticated HTTP request to the specified endpoint with custom headers
     * NOTE: This method is intended for use by subclasses only
     * @param method HTTP method (GET, POST, PUT, DELETE)
     * @param path API endpoint path
     * @param data Optional request body data (for POST/PUT requests)
     * @param customHeaders Optional custom headers to include with the request
     * @param callback Callback function to handle the parsed response
     */
    public function makeRequestWithHeaders(method: String, path: String, ?data: Dynamic, ?customHeaders: Map<String, String>, callback: Dynamic -> Void): Void {
        // Validate method parameter
        if (method == null || method.length == 0) {
            throw new SpotOnException("HTTP method cannot be null or empty", "INVALID_METHOD");
        }
        
        // Validate path parameter
        if (path == null || path.length == 0) {
            throw new SpotOnException("API path cannot be null or empty", "INVALID_PATH");
        }
        
        // Create response handler that includes error handling and parsing
        var responseHandler = function(response: Response): Void {
            try {
                // Handle HTTP errors first
                handleHttpErrors(response, path);
                
                // Parse the response body
                var parsedResponse = parseResponse(response);
                
                // Call the callback with the parsed response
                callback(parsedResponse);
                
            } catch (e: SpotOnException) {
                // Re-throw SpotOn exceptions as-is
                throw e;
            } catch (e: Dynamic) {
                // Wrap other exceptions in a SpotOnException
                throw new SpotOnException("Unexpected error processing response: " + Std.string(e), "RESPONSE_PROCESSING_ERROR", e);
            }
        };
        
        try {
            // Get authentication headers for this request
            var authHeaders = auth.getAuthHeaders();
            
            // Merge authentication headers with custom headers
            var requestHeaders = new Map<String, String>();
            
            // Add authentication headers first
            for (headerName in authHeaders.keys()) {
                requestHeaders.set(headerName, authHeaders.get(headerName));
            }
            
            // Add custom headers (these can override auth headers if needed)
            if (customHeaders != null) {
                for (headerName in customHeaders.keys()) {
                    requestHeaders.set(headerName, customHeaders.get(headerName));
                }
            }
            
            // Make the appropriate HTTP request based on method
            switch (method.toUpperCase()) {
                case "GET":
                    httpClient.get(path, data, requestHeaders, responseHandler);
                case "POST":
                    httpClient.post(path, data, requestHeaders, responseHandler);
                case "PUT":
                    httpClient.put(path, data, requestHeaders, responseHandler);
                case "DELETE":
                    httpClient.delete(path, requestHeaders, responseHandler);
                default:
                    throw new SpotOnException("Unsupported HTTP method: " + method, "UNSUPPORTED_METHOD");
            }
            
        } catch (e: SpotOnException) {
            // Re-throw SpotOn exceptions as-is
            throw e;
        } catch (e: Dynamic) {
            // Wrap network-related errors
            throw new NetworkException("Failed to make HTTP request: " + Std.string(e), "REQUEST_FAILED", e);
        }
    }
    
    /**
     * Handles HTTP errors based on response status codes
     * @param response HTTP response to check for errors
     * @param path API endpoint path for error context
     * @throws SpotOnException if the response indicates an error
     */
    private function handleHttpErrors(response: Response, path: String): Void {
        if (response.success) {
            return; // No error to handle
        }
        
        var errorMessage = "API request failed";
        var errorCode = "API_ERROR";
        var errorDetails = {
            path: path,
            status: response.status,
            body: response.body
        };
        
        // Handle specific HTTP status codes
        switch (response.status) {
            case 400:
                errorMessage = "Bad Request - Invalid request parameters";
                errorCode = "BAD_REQUEST";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 401:
                errorMessage = "Unauthorized - Invalid or missing authentication credentials";
                errorCode = "UNAUTHORIZED";
                throw new AuthenticationException(errorMessage, errorCode, errorDetails);
                
            case 403:
                errorMessage = "Forbidden - Insufficient permissions to access this resource";
                errorCode = "FORBIDDEN";
                throw new AuthenticationException(errorMessage, errorCode, errorDetails);
                
            case 404:
                errorMessage = "Not Found - The requested resource does not exist";
                errorCode = "NOT_FOUND";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 409:
                errorMessage = "Conflict - The request conflicts with the current state of the resource";
                errorCode = "CONFLICT";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 429:
                errorMessage = "Too Many Requests - Rate limit exceeded";
                errorCode = "RATE_LIMIT_EXCEEDED";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 500:
                errorMessage = "Internal Server Error - The server encountered an unexpected condition";
                errorCode = "INTERNAL_SERVER_ERROR";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 502:
                errorMessage = "Bad Gateway - Invalid response from upstream server";
                errorCode = "BAD_GATEWAY";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 503:
                errorMessage = "Service Unavailable - The server is temporarily unavailable";
                errorCode = "SERVICE_UNAVAILABLE";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            case 504:
                errorMessage = "Gateway Timeout - Timeout waiting for upstream server";
                errorCode = "GATEWAY_TIMEOUT";
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
                
            default:
                if (response.status >= 400 && response.status < 500) {
                    errorMessage = "Client Error - HTTP " + response.status;
                    errorCode = "CLIENT_ERROR";
                } else if (response.status >= 500) {
                    errorMessage = "Server Error - HTTP " + response.status;
                    errorCode = "SERVER_ERROR";
                } else if (response.status == 0) {
                    errorMessage = "Network Error - Unable to connect to server";
                    errorCode = "NETWORK_ERROR";
                    throw new NetworkException(errorMessage, errorCode, errorDetails);
                }
                throw new APIException(errorMessage, errorCode, response.status, path, errorDetails);
        }
    }
    
    /**
     * Parses the HTTP response body into a Dynamic object
     * @param response HTTP response to parse
     * @return Parsed response data as Dynamic object
     * @throws SpotOnException if JSON parsing fails
     */
    private function parseResponse(response: Response): Dynamic {
        if (response.body == null || response.body.length == 0) {
            return null; // Empty response is valid for some endpoints
        }
        
        try {
            // Attempt to parse as JSON
            return haxe.Json.parse(response.body);
        } catch (e: Dynamic) {
            // If JSON parsing fails, throw a parsing error
            throw new SpotOnException(
                "Failed to parse response as JSON: " + Std.string(e), 
                "JSON_PARSE_ERROR", 
                {
                    body: response.body,
                    parseError: e
                }
            );
        }
    }
    
    /**
     * Validates request parameters before making API calls
     * NOTE: This method is intended for use by subclasses only
     * @param params Parameters object to validate
     * @throws SpotOnException if validation fails
     */
    public function validateParams(params: Dynamic): Void {
        if (params == null) {
            return; // Null params are acceptable
        }
        
        // Basic validation - can be extended by subclasses
        // This is a placeholder for parameter validation logic
        // Specific endpoints can override this method for custom validation
    }
}