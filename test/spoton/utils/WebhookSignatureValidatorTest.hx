package test.spoton.utils;

import utest.Test;
import utest.Assert;
import spoton.utils.WebhookSignatureValidator;

/**
 * Test suite for WebhookSignatureValidator utility
 * Tests signature validation, HMAC computation, and security functions
 */
class WebhookSignatureValidatorTest extends Test {
    
    function testValidSignatureValidation() {
        var payload = '{"event": "order.created", "data": {"id": "order_123"}}';
        var secret = "webhook_secret_key";
        
        // Compute the expected signature
        var expectedSignature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        var signatureHeader = "sha256=" + expectedSignature;
        
        // Test validation
        var isValid = WebhookSignatureValidator.validateSignature(payload, signatureHeader, secret);
        Assert.isTrue(isValid);
    }
    
    function testInvalidSignatureValidation() {
        var payload = '{"event": "order.created", "data": {"id": "order_123"}}';
        var secret = "webhook_secret_key";
        var invalidSignature = "sha256=invalid_signature_hash";
        
        var isValid = WebhookSignatureValidator.validateSignature(payload, invalidSignature, secret);
        Assert.isFalse(isValid);
    }
    
    function testSignatureValidationWithWrongSecret() {
        var payload = '{"event": "order.created", "data": {"id": "order_123"}}';
        var correctSecret = "correct_secret";
        var wrongSecret = "wrong_secret";
        
        // Generate signature with correct secret
        var correctSignature = WebhookSignatureValidator.computeHmacSha256(payload, correctSecret);
        var signatureHeader = "sha256=" + correctSignature;
        
        // Try to validate with wrong secret
        var isValid = WebhookSignatureValidator.validateSignature(payload, signatureHeader, wrongSecret);
        Assert.isFalse(isValid);
    }
    
    function testSignatureValidationWithModifiedPayload() {
        var originalPayload = '{"event": "order.created", "data": {"id": "order_123"}}';
        var modifiedPayload = '{"event": "order.created", "data": {"id": "order_456"}}';
        var secret = "webhook_secret_key";
        
        // Generate signature for original payload
        var signature = WebhookSignatureValidator.computeHmacSha256(originalPayload, secret);
        var signatureHeader = "sha256=" + signature;
        
        // Try to validate modified payload with original signature
        var isValid = WebhookSignatureValidator.validateSignature(modifiedPayload, signatureHeader, secret);
        Assert.isFalse(isValid);
    }
    
    function testExtractSignatureFromHeader() {
        var validHeader = "sha256=abc123def456";
        var extractedSignature = WebhookSignatureValidator.extractSignatureFromHeader(validHeader);
        Assert.equals("abc123def456", extractedSignature);
    }
    
    function testExtractSignatureFromInvalidHeader() {
        // Test various invalid header formats
        var invalidHeaders = [
            "invalid_format",
            "md5=abc123",
            "sha256:",
            "=abc123",
            "",
            "sha256=abc=def"
        ];
        
        for (header in invalidHeaders) {
            var result = WebhookSignatureValidator.extractSignatureFromHeader(header);
            Assert.isNull(result, 'Header "$header" should return null');
        }
        
        // Test empty signature (should return empty string, not null)
        var emptySignatureResult = WebhookSignatureValidator.extractSignatureFromHeader("sha256=");
        Assert.equals("", emptySignatureResult);
    }
    
    function testExtractSignatureFromNullHeader() {
        var result = WebhookSignatureValidator.extractSignatureFromHeader(null);
        Assert.isNull(result);
    }
    
    function testConstantTimeCompareWithEqualStrings() {
        var str1 = "abc123def456";
        var str2 = "abc123def456";
        
        var result = WebhookSignatureValidator.constantTimeCompare(str1, str2);
        Assert.isTrue(result);
    }
    
    function testConstantTimeCompareWithDifferentStrings() {
        var str1 = "abc123def456";
        var str2 = "abc123def789";
        
        var result = WebhookSignatureValidator.constantTimeCompare(str1, str2);
        Assert.isFalse(result);
    }
    
    function testConstantTimeCompareWithDifferentLengths() {
        var str1 = "abc123";
        var str2 = "abc123def";
        
        var result = WebhookSignatureValidator.constantTimeCompare(str1, str2);
        Assert.isFalse(result);
    }
    
    function testConstantTimeCompareWithNullValues() {
        var result1 = WebhookSignatureValidator.constantTimeCompare(null, "test");
        var result2 = WebhookSignatureValidator.constantTimeCompare("test", null);
        var result3 = WebhookSignatureValidator.constantTimeCompare(null, null);
        
        Assert.isFalse(result1);
        Assert.isFalse(result2);
        Assert.isFalse(result3);
    }
    
    function testConstantTimeCompareWithEmptyStrings() {
        var result1 = WebhookSignatureValidator.constantTimeCompare("", "");
        var result2 = WebhookSignatureValidator.constantTimeCompare("", "test");
        var result3 = WebhookSignatureValidator.constantTimeCompare("test", "");
        
        Assert.isTrue(result1);
        Assert.isFalse(result2);
        Assert.isFalse(result3);
    }
    
    function testHmacSha256Computation() {
        var payload = "test payload";
        var secret = "test secret";
        
        var signature1 = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        var signature2 = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        
        // Same input should produce same output
        Assert.equals(signature1, signature2);
        Assert.notNull(signature1);
        Assert.isTrue(signature1.length > 0);
    }
    
    function testHmacSha256WithDifferentPayloads() {
        var payload1 = "payload one";
        var payload2 = "payload two";
        var secret = "test secret";
        
        var signature1 = WebhookSignatureValidator.computeHmacSha256(payload1, secret);
        var signature2 = WebhookSignatureValidator.computeHmacSha256(payload2, secret);
        
        // Different payloads should produce different signatures
        Assert.notEquals(signature1, signature2);
    }
    
    function testHmacSha256WithDifferentSecrets() {
        var payload = "test payload";
        var secret1 = "secret one";
        var secret2 = "secret two";
        
        var signature1 = WebhookSignatureValidator.computeHmacSha256(payload, secret1);
        var signature2 = WebhookSignatureValidator.computeHmacSha256(payload, secret2);
        
        // Different secrets should produce different signatures
        Assert.notEquals(signature1, signature2);
    }
    
    function testHmacSha256WithEmptyPayload() {
        var payload = "";
        var secret = "test secret";
        
        var signature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        Assert.notNull(signature);
        Assert.isTrue(signature.length > 0);
    }
    
    function testHmacSha256WithEmptySecret() {
        var payload = "test payload";
        var secret = "";
        
        var signature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        Assert.notNull(signature);
        Assert.isTrue(signature.length > 0);
    }
    
    function testCompleteWorkflowWithRealWorldExample() {
        // Simulate a real webhook payload
        var payload = '{"event_type":"order.created","location_id":"loc_123","data":{"id":"order_456","total":2599,"items":[{"name":"Burger","price":1299}]}}';
        var secret = "my_webhook_secret_2023";
        
        // Step 1: Compute signature (this would be done by SpotOn)
        var computedSignature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        var webhookHeader = "sha256=" + computedSignature;
        
        // Step 2: Validate signature (this would be done by the client)
        var isValid = WebhookSignatureValidator.validateSignature(payload, webhookHeader, secret);
        Assert.isTrue(isValid);
        
        // Step 3: Test with tampered payload
        var tamperedPayload = StringTools.replace(payload, "order_456", "order_999");
        var isValidTampered = WebhookSignatureValidator.validateSignature(tamperedPayload, webhookHeader, secret);
        Assert.isFalse(isValidTampered);
    }
    
    function testSignatureValidationWithSpecialCharacters() {
        var payload = '{"message": "Hello, world! Special chars: àáâãäåæçèéêë & symbols: @#$%^&*()"}';
        var secret = "secret_with_special_chars_!@#$%^&*()";
        
        var signature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        var signatureHeader = "sha256=" + signature;
        
        var isValid = WebhookSignatureValidator.validateSignature(payload, signatureHeader, secret);
        Assert.isTrue(isValid);
    }
    
    function testSignatureValidationWithLargePayload() {
        // Create a large payload
        var largeData = [];
        for (i in 0...1000) {
            largeData.push('{"id": "item_$i", "name": "Item $i", "price": ${i * 100}}');
        }
        var payload = '{"items": [' + largeData.join(",") + ']}';
        var secret = "large_payload_secret";
        
        var signature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        var signatureHeader = "sha256=" + signature;
        
        var isValid = WebhookSignatureValidator.validateSignature(payload, signatureHeader, secret);
        Assert.isTrue(isValid);
    }
    
    function testEdgeCaseSignatureFormats() {
        var payload = "test";
        var secret = "secret";
        var validSignature = WebhookSignatureValidator.computeHmacSha256(payload, secret);
        
        // Test case sensitivity
        var upperCaseHeader = "SHA256=" + validSignature;
        var isValidUpper = WebhookSignatureValidator.validateSignature(payload, upperCaseHeader, secret);
        Assert.isFalse(isValidUpper); // Should be false because we expect lowercase "sha256"
        
        // Test with extra whitespace (should fail)
        var whitespaceHeader = " sha256=" + validSignature + " ";
        var isValidWhitespace = WebhookSignatureValidator.validateSignature(payload, whitespaceHeader, secret);
        Assert.isFalse(isValidWhitespace);
    }
}