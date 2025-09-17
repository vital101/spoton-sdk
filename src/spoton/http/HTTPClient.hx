package spoton.http;

import spoton.http.Response;

/**
 * HTTP client interface for making API requests
 * Platform-agnostic interface that will be implemented for each target platform
 */
interface HTTPClient {
    /**
     * Set a default header for all requests
     * @param name Header name
     * @param value Header value
     */
    function setDefaultHeader(name: String, value: String): Void;
    
    /**
     * Perform a GET request
     * @param path The API endpoint path
     * @param params Optional query parameters
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    function get(path: String, ?params: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void;
    
    /**
     * Perform a POST request
     * @param path The API endpoint path
     * @param data Optional request body data
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    function post(path: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void;
    
    /**
     * Perform a PUT request
     * @param path The API endpoint path
     * @param data Optional request body data
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    function put(path: String, ?data: Dynamic, ?headers: Map<String, String>, callback: Response -> Void): Void;
    
    /**
     * Perform a DELETE request
     * @param path The API endpoint path
     * @param headers Optional request-specific headers
     * @param callback Callback function to handle the response
     */
    function delete(path: String, ?headers: Map<String, String>, callback: Response -> Void): Void;
}