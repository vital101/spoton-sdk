package spoton.errors;

/**
 * Base exception class for all SpotOn SDK errors.
 * Extends haxe.Exception to provide consistent error handling across all target platforms.
 */
class SpotOnException extends haxe.Exception {
    /**
     * Error code identifying the specific type of error
     */
    public var errorCode: String;
    
    /**
     * Additional details about the error
     */
    public var errorDetails: Dynamic;
    
    /**
     * Creates a new SpotOnException
     * @param message Human-readable error message
     * @param code Error code identifying the specific error type
     * @param details Optional additional error details
     */
    public function new(message: String, code: String, ?details: Dynamic) {
        super(message);
        this.errorCode = code;
        this.errorDetails = details;
    }
    
    /**
     * Gets the SpotOn error code
     */
    public function getErrorCode(): String {
        return this.errorCode;
    }
    
    /**
     * Gets the SpotOn error details
     */
    public function getErrorDetails(): Dynamic {
        return this.errorDetails;
    }
}