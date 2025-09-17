package test.spoton.auth;

import utest.Test;
import utest.Assert;
import spoton.auth.AuthenticationManager;
import spoton.auth.AuthenticationManagerImpl;
import spoton.auth.Credentials;
import spoton.errors.AuthenticationException;

/**
 * Unit tests for AuthenticationManager implementation
 * Tests authentication logic, token handling, and credential validation
 */
class AuthenticationManagerTest extends Test {
    
    private var validApiKeyCredentials: Credentials;
    private var validOAuthCredentials: Credentials;
    private var invalidCredentials: Credentials;
    private var emptyCredentials: Credentials;
    private var shortApiKeyCredentials: Credentials;
    
    public function setup() {
        // Valid API key credentials
        validApiKeyCredentials = {
            apiKey: "valid_api_key_12345678901234567890"
        };
        
        // Valid OAuth credentials (for future implementation)
        validOAuthCredentials = {
            clientId: "test_client_id",
            clientSecret: "test_client_secret"
        };
        
        // Invalid credentials (null values)
        invalidCredentials = {
            apiKey: null,
            clientId: null,
            clientSecret: null
        };
        
        // Empty credentials
        emptyCredentials = {
            apiKey: "",
            clientId: "",
            clientSecret: ""
        };
        
        // Short API key (invalid)
        shortApiKeyCredentials = {
            apiKey: "short"
        };
    }
    
    /**
     * Test successful API key authentication
     */
    public function testSuccessfulApiKeyAuthentication() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        
        var result = authManager.authenticate();
        Assert.isTrue(result, "Authentication should succeed with valid API key");
        Assert.isTrue(authManager.isAuthenticatedStatus(), "Manager should be in authenticated state");
    }
    
    /**
     * Test authentication with null API key throws exception
     */
    public function testAuthenticationWithNullApiKey() {
        var authManager = new AuthenticationManagerImpl(invalidCredentials);
        
        Assert.raises(function() {
            authManager.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test authentication with empty API key throws exception
     */
    public function testAuthenticationWithEmptyApiKey() {
        var authManager = new AuthenticationManagerImpl(emptyCredentials);
        
        Assert.raises(function() {
            authManager.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test authentication with short API key throws exception
     */
    public function testAuthenticationWithShortApiKey() {
        var authManager = new AuthenticationManagerImpl(shortApiKeyCredentials);
        
        Assert.raises(function() {
            authManager.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test OAuth authentication throws not implemented exception
     */
    public function testOAuthAuthenticationNotImplemented() {
        var authManager = new AuthenticationManagerImpl(validOAuthCredentials);
        
        Assert.raises(function() {
            authManager.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test getting auth headers after successful authentication
     */
    public function testGetAuthHeadersAfterAuthentication() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        authManager.authenticate();
        
        var headers = authManager.getAuthHeaders();
        Assert.notNull(headers, "Auth headers should not be null");
        Assert.isTrue(headers.exists("Authorization"), "Authorization header should exist");
        Assert.isTrue(headers.exists("Content-Type"), "Content-Type header should exist");
        
        var authHeader = headers.get("Authorization");
        Assert.isTrue(authHeader.indexOf("Bearer") == 0, "Authorization header should start with 'Bearer'");
        Assert.isTrue(authHeader.indexOf(validApiKeyCredentials.apiKey) > 0, "Authorization header should contain API key");
        
        var contentType = headers.get("Content-Type");
        Assert.equals("application/json", contentType, "Content-Type should be application/json");
    }
    
    /**
     * Test getting auth headers before authentication throws exception
     */
    public function testGetAuthHeadersBeforeAuthentication() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        
        Assert.raises(function() {
            authManager.getAuthHeaders();
        }, AuthenticationException);
    }
    
    /**
     * Test authentication state transitions
     */
    public function testAuthenticationStateTransitions() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        
        // Initially not authenticated
        Assert.isFalse(authManager.isAuthenticatedStatus(), "Should not be authenticated initially");
        
        // After successful authentication
        authManager.authenticate();
        Assert.isTrue(authManager.isAuthenticatedStatus(), "Should be authenticated after authenticate()");
        
        // Re-authentication should reset and succeed
        var result = authManager.authenticate();
        Assert.isTrue(result, "Re-authentication should succeed");
        Assert.isTrue(authManager.isAuthenticatedStatus(), "Should remain authenticated after re-authentication");
    }
    
    /**
     * Test authentication failure scenarios
     */
    public function testAuthenticationFailureScenarios() {
        // Test with completely empty credentials object
        var emptyCredsManager = new AuthenticationManagerImpl({});
        Assert.raises(function() {
            emptyCredsManager.authenticate();
        }, AuthenticationException);
        
        // Test with partial OAuth credentials (missing secret)
        var partialOAuthCreds: Credentials = { clientId: "test_id" };
        var partialOAuthManager = new AuthenticationManagerImpl(partialOAuthCreds);
        Assert.raises(function() {
            partialOAuthManager.authenticate();
        }, AuthenticationException);
        
        // Test with partial OAuth credentials (missing id)
        var partialOAuthCreds2: Credentials = { clientSecret: "test_secret" };
        var partialOAuthManager2 = new AuthenticationManagerImpl(partialOAuthCreds2);
        Assert.raises(function() {
            partialOAuthManager2.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test token refresh functionality
     */
    public function testTokenRefreshWithApiKey() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        authManager.authenticate();
        
        // For API key authentication, refresh should succeed (no-op)
        var result = authManager.refreshTokenIfNeeded();
        Assert.isTrue(result, "Token refresh should succeed for API key authentication");
        Assert.isTrue(authManager.isAuthenticatedStatus(), "Should remain authenticated after refresh");
    }
    
    /**
     * Test token refresh before authentication throws exception
     */
    public function testTokenRefreshBeforeAuthentication() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        
        Assert.raises(function() {
            authManager.refreshTokenIfNeeded();
        }, AuthenticationException);
    }
    
    /**
     * Test token refresh with OAuth throws not implemented exception
     */
    public function testTokenRefreshWithOAuthNotImplemented() {
        var authManager = new AuthenticationManagerImpl(validOAuthCredentials);
        
        // First authenticate (this will fail, but we need to test the refresh path)
        // Since OAuth is not implemented, we can't test the refresh directly
        // This test documents the expected behavior for future OAuth implementation
        Assert.raises(function() {
            authManager.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test credential validation edge cases
     */
    public function testCredentialValidationEdgeCases() {
        // Test with whitespace-only API key
        var whitespaceCredentials: Credentials = { apiKey: "   " };
        var whitespaceManager = new AuthenticationManagerImpl(whitespaceCredentials);
        // This should fail because trimming is not implemented, treating as short key
        Assert.raises(function() {
            whitespaceManager.authenticate();
        }, AuthenticationException);
        
        // Test with exactly 10 character API key (boundary case)
        var boundaryCredentials: Credentials = { apiKey: "1234567890" };
        var boundaryManager = new AuthenticationManagerImpl(boundaryCredentials);
        var result = boundaryManager.authenticate();
        Assert.isTrue(result, "10-character API key should be valid");
        
        // Test with 9 character API key (should fail)
        var shortBoundaryCredentials: Credentials = { apiKey: "123456789" };
        var shortBoundaryManager = new AuthenticationManagerImpl(shortBoundaryCredentials);
        Assert.raises(function() {
            shortBoundaryManager.authenticate();
        }, AuthenticationException);
    }
    
    /**
     * Test auth headers are properly copied (not referenced)
     */
    public function testAuthHeadersCopying() {
        var authManager = new AuthenticationManagerImpl(validApiKeyCredentials);
        authManager.authenticate();
        
        var headers1 = authManager.getAuthHeaders();
        var headers2 = authManager.getAuthHeaders();
        
        // Headers should have same content but be different objects
        Assert.equals(headers1.get("Authorization"), headers2.get("Authorization"));
        
        // Modifying one should not affect the other
        headers1.set("Test-Header", "test-value");
        Assert.isFalse(headers2.exists("Test-Header"), "Modifying one header map should not affect another");
    }
    
    /**
     * Test authentication with mixed credential types
     */
    public function testAuthenticationWithMixedCredentials() {
        // Test with both API key and OAuth credentials (API key should take precedence)
        var mixedCredentials: Credentials = {
            apiKey: "valid_api_key_12345678901234567890",
            clientId: "test_client_id",
            clientSecret: "test_client_secret"
        };
        
        var authManager = new AuthenticationManagerImpl(mixedCredentials);
        var result = authManager.authenticate();
        
        // Should succeed using API key authentication
        Assert.isTrue(result, "Authentication should succeed with mixed credentials using API key");
        Assert.isTrue(authManager.isAuthenticatedStatus(), "Should be authenticated");
        
        var headers = authManager.getAuthHeaders();
        Assert.isTrue(headers.get("Authorization").indexOf("Bearer") == 0, "Should use Bearer token format for API key");
    }
}