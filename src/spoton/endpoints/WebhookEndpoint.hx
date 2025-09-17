package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.utils.WebhookSignatureValidator;

/**
 * WebhookEndpoint provides utilities for handling SpotOn webhook events.
 * This includes signature validation and webhook event processing utilities.
 */
class WebhookEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new WebhookEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Validates the signature of a webhook request to ensure it came from SpotOn
     * @param payload The raw webhook payload body
     * @param signature The signature header from the webhook request
     * @param secret The webhook secret configured in SpotOn dashboard
     * @return True if the signature is valid, false otherwise
     * @throws SpotOnException if validation parameters are invalid
     */
    public function validateSignature(payload: String, signature: String, secret: String): Bool {
        // Validate required parameters
        if (payload == null) {
            throw new spoton.errors.SpotOnException("Webhook payload cannot be null", "INVALID_PAYLOAD");
        }
        
        if (signature == null || signature.length == 0) {
            throw new spoton.errors.SpotOnException("Webhook signature cannot be null or empty", "INVALID_SIGNATURE");
        }
        
        if (secret == null || secret.length == 0) {
            throw new spoton.errors.SpotOnException("Webhook secret cannot be null or empty", "INVALID_SECRET");
        }
        
        // Use the WebhookSignatureValidator utility to perform HMAC-SHA256 validation
        return WebhookSignatureValidator.validateSignature(payload, signature, secret);
    }
    
    /**
     * Extracts the signature from webhook headers
     * This is a convenience method for extracting the signature from common webhook header formats
     * @param headers Map of HTTP headers from the webhook request
     * @return The signature string, or null if not found
     */
    public function extractSignatureFromHeaders(headers: Map<String, String>): String {
        if (headers == null) {
            return null;
        }
        
        // Check common header names for webhook signatures
        var signatureHeaders = [
            "X-SpotOn-Signature",
            "X-Signature", 
            "Signature",
            "X-Hub-Signature-256"
        ];
        
        for (headerName in signatureHeaders) {
            var signature = headers.get(headerName);
            if (signature != null && signature.length > 0) {
                return signature;
            }
            
            // Also check lowercase versions
            var lowerHeaderName = headerName.toLowerCase();
            signature = headers.get(lowerHeaderName);
            if (signature != null && signature.length > 0) {
                return signature;
            }
        }
        
        return null;
    }
}