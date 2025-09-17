package spoton.errors;

/**
 * Exception thrown when authentication or authorization fails.
 * This includes invalid credentials, expired tokens, insufficient permissions, etc.
 */
class AuthenticationException extends SpotOnException {
    
    /**
     * Creates a new AuthenticationException
     * @param message Human-readable error message describing the authentication failure
     * @param code Error code identifying the specific authentication error type
     * @param details Optional additional error details (e.g., token expiration time, required permissions)
     */
    public function new(message: String, code: String, ?details: Dynamic) {
        super(message, code, details);
    }
}