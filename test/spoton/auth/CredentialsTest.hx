package test.spoton.auth;

import utest.Test;
import utest.Assert;
import spoton.auth.Credentials;

/**
 * Unit tests for Credentials typedef
 * Tests credential creation, validation, and serialization
 */
class CredentialsTest extends Test {
    
    /**
     * Test creating credentials with API key only
     */
    public function testCreateCredentialsWithApiKey() {
        var credentials: Credentials = {
            apiKey: "test_api_key_12345"
        };
        
        Assert.equals("test_api_key_12345", credentials.apiKey);
        Assert.isNull(credentials.clientId);
        Assert.isNull(credentials.clientSecret);
    }
    
    /**
     * Test creating credentials with OAuth client credentials only
     */
    public function testCreateCredentialsWithOAuth() {
        var credentials: Credentials = {
            clientId: "test_client_id",
            clientSecret: "test_client_secret"
        };
        
        Assert.isNull(credentials.apiKey);
        Assert.equals("test_client_id", credentials.clientId);
        Assert.equals("test_client_secret", credentials.clientSecret);
    }
    
    /**
     * Test creating credentials with both API key and OAuth
     */
    public function testCreateCredentialsWithBoth() {
        var credentials: Credentials = {
            apiKey: "test_api_key_12345",
            clientId: "test_client_id",
            clientSecret: "test_client_secret"
        };
        
        Assert.equals("test_api_key_12345", credentials.apiKey);
        Assert.equals("test_client_id", credentials.clientId);
        Assert.equals("test_client_secret", credentials.clientSecret);
    }
    
    /**
     * Test creating empty credentials object
     */
    public function testCreateEmptyCredentials() {
        var credentials: Credentials = {};
        
        Assert.isNull(credentials.apiKey);
        Assert.isNull(credentials.clientId);
        Assert.isNull(credentials.clientSecret);
    }
    
    /**
     * Test credentials with empty string values
     */
    public function testCredentialsWithEmptyStrings() {
        var credentials: Credentials = {
            apiKey: "",
            clientId: "",
            clientSecret: ""
        };
        
        Assert.equals("", credentials.apiKey);
        Assert.equals("", credentials.clientId);
        Assert.equals("", credentials.clientSecret);
    }
    
    /**
     * Test credentials serialization to JSON
     */
    public function testCredentialsSerialization() {
        var credentials: Credentials = {
            apiKey: "test_api_key_12345",
            clientId: "test_client_id",
            clientSecret: "test_client_secret"
        };
        
        var json = haxe.Json.stringify(credentials);
        Assert.notNull(json);
        Assert.isTrue(json.indexOf("test_api_key_12345") >= 0);
        Assert.isTrue(json.indexOf("test_client_id") >= 0);
        Assert.isTrue(json.indexOf("test_client_secret") >= 0);
    }
    
    /**
     * Test credentials deserialization from JSON
     */
    public function testCredentialsDeserialization() {
        var jsonString = '{"apiKey":"test_api_key_12345","clientId":"test_client_id","clientSecret":"test_client_secret"}';
        var credentials: Credentials = haxe.Json.parse(jsonString);
        
        Assert.equals("test_api_key_12345", credentials.apiKey);
        Assert.equals("test_client_id", credentials.clientId);
        Assert.equals("test_client_secret", credentials.clientSecret);
    }
    
    /**
     * Test partial credentials deserialization from JSON
     */
    public function testPartialCredentialsDeserialization() {
        // Test API key only
        var apiKeyJson = '{"apiKey":"test_api_key_12345"}';
        var apiKeyCredentials: Credentials = haxe.Json.parse(apiKeyJson);
        
        Assert.equals("test_api_key_12345", apiKeyCredentials.apiKey);
        Assert.isNull(apiKeyCredentials.clientId);
        Assert.isNull(apiKeyCredentials.clientSecret);
        
        // Test OAuth only
        var oauthJson = '{"clientId":"test_client_id","clientSecret":"test_client_secret"}';
        var oauthCredentials: Credentials = haxe.Json.parse(oauthJson);
        
        Assert.isNull(oauthCredentials.apiKey);
        Assert.equals("test_client_id", oauthCredentials.clientId);
        Assert.equals("test_client_secret", oauthCredentials.clientSecret);
    }
    
    /**
     * Test credentials validation logic (helper function)
     */
    public function testCredentialsValidation() {
        // Valid API key credentials
        var validApiKey: Credentials = { apiKey: "valid_key_12345" };
        Assert.isTrue(isValidCredentials(validApiKey), "Valid API key should be considered valid");
        
        // Valid OAuth credentials
        var validOAuth: Credentials = { 
            clientId: "client_id", 
            clientSecret: "client_secret" 
        };
        Assert.isTrue(isValidCredentials(validOAuth), "Valid OAuth credentials should be considered valid");
        
        // Invalid credentials (empty)
        var invalidEmpty: Credentials = {};
        Assert.isFalse(isValidCredentials(invalidEmpty), "Empty credentials should be invalid");
        
        // Invalid credentials (empty strings)
        var invalidEmptyStrings: Credentials = { 
            apiKey: "", 
            clientId: "", 
            clientSecret: "" 
        };
        Assert.isFalse(isValidCredentials(invalidEmptyStrings), "Empty string credentials should be invalid");
        
        // Invalid OAuth (missing secret)
        var invalidOAuth1: Credentials = { clientId: "client_id" };
        Assert.isFalse(isValidCredentials(invalidOAuth1), "OAuth credentials missing secret should be invalid");
        
        // Invalid OAuth (missing id)
        var invalidOAuth2: Credentials = { clientSecret: "client_secret" };
        Assert.isFalse(isValidCredentials(invalidOAuth2), "OAuth credentials missing id should be invalid");
    }
    
    /**
     * Test credentials edge cases
     */
    public function testCredentialsEdgeCases() {
        // Test with null values explicitly set
        var nullCredentials: Credentials = {
            apiKey: null,
            clientId: null,
            clientSecret: null
        };
        
        Assert.isNull(nullCredentials.apiKey);
        Assert.isNull(nullCredentials.clientId);
        Assert.isNull(nullCredentials.clientSecret);
        
        // Test with whitespace values
        var whitespaceCredentials: Credentials = {
            apiKey: "   ",
            clientId: "   ",
            clientSecret: "   "
        };
        
        Assert.equals("   ", whitespaceCredentials.apiKey);
        Assert.equals("   ", whitespaceCredentials.clientId);
        Assert.equals("   ", whitespaceCredentials.clientSecret);
    }
    
    /**
     * Test credentials copying/cloning
     */
    public function testCredentialsCopying() {
        var original: Credentials = {
            apiKey: "original_api_key",
            clientId: "original_client_id",
            clientSecret: "original_client_secret"
        };
        
        // Create a copy by creating new object with same values
        var copy: Credentials = {
            apiKey: original.apiKey,
            clientId: original.clientId,
            clientSecret: original.clientSecret
        };
        
        // Verify values are the same
        Assert.equals(original.apiKey, copy.apiKey);
        Assert.equals(original.clientId, copy.clientId);
        Assert.equals(original.clientSecret, copy.clientSecret);
        
        // Modify copy and verify original is unchanged
        copy.apiKey = "modified_api_key";
        Assert.equals("original_api_key", original.apiKey);
        Assert.equals("modified_api_key", copy.apiKey);
    }
    
    /**
     * Test credentials with special characters
     */
    public function testCredentialsWithSpecialCharacters() {
        var specialCredentials: Credentials = {
            apiKey: "api_key_with-special.chars@123!",
            clientId: "client-id_with.special@chars",
            clientSecret: "client/secret\\with|special*chars"
        };
        
        Assert.equals("api_key_with-special.chars@123!", specialCredentials.apiKey);
        Assert.equals("client-id_with.special@chars", specialCredentials.clientId);
        Assert.equals("client/secret\\with|special*chars", specialCredentials.clientSecret);
        
        // Test serialization/deserialization with special characters
        var json = haxe.Json.stringify(specialCredentials);
        var deserialized: Credentials = haxe.Json.parse(json);
        
        Assert.equals(specialCredentials.apiKey, deserialized.apiKey);
        Assert.equals(specialCredentials.clientId, deserialized.clientId);
        Assert.equals(specialCredentials.clientSecret, deserialized.clientSecret);
    }
    
    /**
     * Helper function to validate credentials
     * This mimics the validation logic that would be used in the authentication manager
     */
    private function isValidCredentials(credentials: Credentials): Bool {
        if (credentials == null) return false;
        
        // Check for API key authentication
        if (credentials.apiKey != null && credentials.apiKey.length > 0) {
            return true;
        }
        
        // Check for OAuth authentication
        if (credentials.clientId != null && credentials.clientId.length > 0 &&
            credentials.clientSecret != null && credentials.clientSecret.length > 0) {
            return true;
        }
        
        return false;
    }
}