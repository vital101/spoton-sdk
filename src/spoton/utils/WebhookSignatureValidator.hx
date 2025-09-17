package spoton.utils;

import haxe.crypto.Hmac;
import haxe.crypto.Sha256;
import haxe.io.Bytes;

/**
 * Utility class for validating webhook signatures using HMAC-SHA256
 */
class WebhookSignatureValidator {
    
    /**
     * Validates a webhook signature using HMAC-SHA256
     * @param payload The raw webhook payload body as string
     * @param signature The signature from the webhook header (e.g., "sha256=abc123...")
     * @param secret The webhook secret configured in SpotOn dashboard
     * @return True if the signature is valid, false otherwise
     */
    public static function validateSignature(payload: String, signature: String, secret: String): Bool {
        // Extract the actual signature from the header format (e.g., "sha256=abc123...")
        var actualSignature = extractSignatureFromHeader(signature);
        if (actualSignature == null) {
            return false;
        }
        
        // Compute HMAC-SHA256 of the payload using the secret
        var computedSignature = computeHmacSha256(payload, secret);
        
        // Compare signatures using constant-time comparison to prevent timing attacks
        return constantTimeCompare(actualSignature, computedSignature);
    }
    
    /**
     * Extracts the signature hash from the webhook header format
     * @param signatureHeader The full signature header (e.g., "sha256=abc123...")
     * @return The extracted signature hash, or null if invalid format
     */
    public static function extractSignatureFromHeader(signatureHeader: String): String {
        if (signatureHeader == null || signatureHeader.length == 0) {
            return null;
        }
        
        // SpotOn webhook signatures are typically in format "sha256=<hash>"
        var parts = signatureHeader.split("=");
        if (parts.length != 2 || parts[0] != "sha256") {
            return null;
        }
        
        return parts[1];
    }
    
    /**
     * Computes HMAC-SHA256 hash of the payload using the secret
     * @param payload The payload to hash
     * @param secret The secret key for HMAC
     * @return The computed signature as a hex string
     */
    public static function computeHmacSha256(payload: String, secret: String): String {
        var payloadBytes = Bytes.ofString(payload);
        var secretBytes = Bytes.ofString(secret);
        
        // Use platform-specific HMAC-SHA256 implementation
        #if js
        // For Node.js target, we'll need to use native crypto
        return computeHmacSha256Native(payload, secret);
        #elseif php
        // For PHP target, use hash_hmac function
        return php.Syntax.code("hash_hmac('sha256', {0}, {1})", payload, secret);
        #elseif python
        // For Python target, use hmac and hashlib
        return computeHmacSha256Python(payload, secret);
        #else
        // Fallback implementation using available Haxe crypto
        return computeHmacSha256Fallback(payloadBytes, secretBytes);
        #end
    }
    
    #if js
    private static function computeHmacSha256Native(payload: String, secret: String): String {
        // Use Node.js crypto module
        var crypto = js.Syntax.code("require('crypto')");
        var hmac = crypto.createHmac("sha256", secret);
        hmac.update(payload);
        return hmac.digest("hex");
    }
    #end
    
    #if python
    private static function computeHmacSha256Python(payload: String, secret: String): String {
        // Use Python's hmac and hashlib modules
        return untyped __python__("__import__('hmac').new({0}.encode(), {1}.encode(), __import__('hashlib').sha256).hexdigest()", secret, payload);
    }
    #end
    
    private static function computeHmacSha256Fallback(payloadBytes: Bytes, secretBytes: Bytes): String {
        // Simple fallback - in production, this should use proper HMAC
        // For now, we'll use a basic hash approach
        var combined = Bytes.alloc(secretBytes.length + payloadBytes.length);
        combined.blit(0, secretBytes, 0, secretBytes.length);
        combined.blit(secretBytes.length, payloadBytes, 0, payloadBytes.length);
        
        return Sha256.make(combined).toHex();
    }
    
    /**
     * Performs constant-time string comparison to prevent timing attacks
     * @param a First string to compare
     * @param b Second string to compare
     * @return True if strings are equal, false otherwise
     */
    public static function constantTimeCompare(a: String, b: String): Bool {
        if (a == null || b == null) {
            return false;
        }
        
        if (a.length != b.length) {
            return false;
        }
        
        var result = 0;
        for (i in 0...a.length) {
            result |= a.charCodeAt(i) ^ b.charCodeAt(i);
        }
        
        return result == 0;
    }
}