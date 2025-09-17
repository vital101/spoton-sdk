package spoton.errors;

/**
 * Exception thrown when network-related errors occur during API communication.
 * This includes connection timeouts, DNS resolution failures, and other network connectivity issues.
 */
class NetworkException extends SpotOnException {
    /**
     * Creates a new NetworkException
     * @param message Human-readable error message describing the network issue
     * @param code Error code identifying the specific network error type
     * @param details Optional additional error details (e.g., timeout duration, host info)
     */
    public function new(message: String, code: String, ?details: Dynamic) {
        super(message, code, details);
    }
}