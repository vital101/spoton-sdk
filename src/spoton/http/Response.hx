package spoton.http;

/**
 * HTTP response data structure
 */
typedef Response = {
    /**
     * HTTP status code (e.g., 200, 404, 500)
     */
    var status: Int;
    
    /**
     * Response headers
     */
    var headers: Map<String, String>;
    
    /**
     * Response body as string
     */
    var body: String;
    
    /**
     * Parsed JSON data (null if parsing failed or response is not JSON)
     */
    var data: Dynamic;
    
    /**
     * Whether the request was successful (status 200-299)
     */
    var success: Bool;
}