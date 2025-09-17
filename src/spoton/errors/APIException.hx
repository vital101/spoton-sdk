package spoton.errors;

/**
 * Exception thrown when API requests fail due to HTTP errors.
 * Extends SpotOnException to provide HTTP-specific error information.
 */
class APIException extends SpotOnException {
    /**
     * HTTP status code returned by the API
     */
    public var httpStatus: Int;
    
    /**
     * API endpoint that caused the error
     */
    public var endpoint: String;
    
    /**
     * Creates a new APIException
     * @param message Human-readable error message
     * @param code Error code identifying the specific error type
     * @param httpStatus HTTP status code returned by the API
     * @param endpoint API endpoint that caused the error
     * @param details Optional additional error details
     */
    public function new(message: String, code: String, httpStatus: Int, endpoint: String, ?details: Dynamic) {
        super(message, code, details);
        this.httpStatus = httpStatus;
        this.endpoint = endpoint;
    }
    
    /**
     * Gets the HTTP status code
     */
    public function getHttpStatus(): Int {
        return this.httpStatus;
    }
    
    /**
     * Gets the API endpoint that caused the error
     */
    public function getEndpoint(): String {
        return this.endpoint;
    }
}