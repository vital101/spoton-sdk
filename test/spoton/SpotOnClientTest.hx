package test.spoton;

import utest.Test;
import utest.Assert;
import spoton.SpotOnClient;
import spoton.auth.Credentials;
import spoton.errors.SpotOnException;
import test.spoton.auth.MockAuthenticationManager;
import test.spoton.http.MockHTTPClient;

/**
 * Unit tests for SpotOnClient
 * Tests client initialization, endpoint accessibility, and authentication integration
 */
class SpotOnClientTest extends Test {
    
    private var validApiKeyCredentials: Credentials;
    private var validOAuthCredentials: Credentials;
    private var invalidCredentials: Credentials;
    
    public function setup() {
        // Valid API key credentials
        validApiKeyCredentials = {
            apiKey: "test_api_key_12345_valid_length"
        };
        
        // Valid OAuth credentials
        validOAuthCredentials = {
            clientId: "test_client_id",
            clientSecret: "test_client_secret"
        };
        
        // Invalid credentials (empty)
        invalidCredentials = {
            apiKey: "",
            clientId: "",
            clientSecret: ""
        };
    }
    
    /**
     * Test client construction with valid API key credentials
     */
    public function testClientConstructionWithApiKey() {
        var client = new SpotOnClient(validApiKeyCredentials);
        
        Assert.notNull(client);
        Assert.notNull(client.business);
        Assert.notNull(client.orders);
        Assert.notNull(client.menus);
        Assert.notNull(client.loyalty);
        Assert.notNull(client.reporting);
        Assert.notNull(client.labor);
        Assert.notNull(client.onboarding);
        Assert.notNull(client.webhooks);
    }
    
    /**
     * Test client construction with valid OAuth credentials
     */
    public function testClientConstructionWithOAuth() {
        var client = new SpotOnClient(validOAuthCredentials);
        
        Assert.notNull(client);
        Assert.notNull(client.business);
        Assert.notNull(client.orders);
        Assert.notNull(client.menus);
        Assert.notNull(client.loyalty);
        Assert.notNull(client.reporting);
        Assert.notNull(client.labor);
        Assert.notNull(client.onboarding);
        Assert.notNull(client.webhooks);
    }
    
    /**
     * Test client construction with custom base URL
     */
    public function testClientConstructionWithCustomBaseUrl() {
        var customBaseUrl = "https://api-staging.spoton.com";
        var client = new SpotOnClient(validApiKeyCredentials, customBaseUrl);
        
        Assert.notNull(client);
        // All endpoints should still be initialized
        Assert.notNull(client.business);
        Assert.notNull(client.orders);
        Assert.notNull(client.menus);
        Assert.notNull(client.loyalty);
        Assert.notNull(client.reporting);
        Assert.notNull(client.labor);
        Assert.notNull(client.onboarding);
        Assert.notNull(client.webhooks);
    }
    
    /**
     * Test client construction with null credentials throws exception
     */
    public function testClientConstructionWithNullCredentials() {
        Assert.raises(function() {
            new SpotOnClient(null);
        }, SpotOnException);
    }
    
    /**
     * Test endpoint initialization and accessibility
     */
    public function testEndpointInitialization() {
        var client = new SpotOnClient(validApiKeyCredentials);
        
        // Verify all endpoints are properly initialized and accessible
        Assert.notNull(client.business, "Business endpoint should be initialized");
        Assert.notNull(client.orders, "Orders endpoint should be initialized");
        Assert.notNull(client.menus, "Menus endpoint should be initialized");
        Assert.notNull(client.loyalty, "Loyalty endpoint should be initialized");
        Assert.notNull(client.reporting, "Reporting endpoint should be initialized");
        Assert.notNull(client.labor, "Labor endpoint should be initialized");
        Assert.notNull(client.onboarding, "Onboarding endpoint should be initialized");
        Assert.notNull(client.webhooks, "Webhooks endpoint should be initialized");
        
        // Verify endpoints are different instances
        Assert.notEquals(client.business, client.orders);
        Assert.notEquals(client.orders, client.menus);
        Assert.notEquals(client.menus, client.loyalty);
    }
    
    /**
     * Test successful authentication flow
     */
    public function testSuccessfulAuthentication() {
        var client = new SpotOnClient(validApiKeyCredentials);
        
        // Authentication should succeed with valid credentials
        var result = client.authenticate();
        Assert.isTrue(result, "Authentication should succeed with valid credentials");
    }
    
    /**
     * Test authentication with different credential types
     */
    public function testAuthenticationWithDifferentCredentialTypes() {
        // Test with API key credentials
        var apiKeyClient = new SpotOnClient(validApiKeyCredentials);
        var apiKeyResult = apiKeyClient.authenticate();
        Assert.isTrue(apiKeyResult, "Authentication should succeed with API key credentials");
        
        // Test with OAuth credentials - should throw exception since OAuth is not implemented yet
        var oauthClient = new SpotOnClient(validOAuthCredentials);
        Assert.raises(function() {
            oauthClient.authenticate();
        }, SpotOnException);
    }
    
    /**
     * Test authentication error handling
     */
    public function testAuthenticationErrorHandling() {
        // Create client with credentials that will cause authentication to fail
        var client = new SpotOnClient(invalidCredentials);
        
        // Authentication should throw SpotOnException
        Assert.raises(function() {
            client.authenticate();
        }, SpotOnException);
    }
    
    /**
     * Test client construction with various configuration combinations
     */
    public function testClientConfigurationVariations() {
        // Test with minimal API key credentials
        var minimalApiKey: Credentials = { apiKey: "valid_api_key_minimum_length" };
        var client1 = new SpotOnClient(minimalApiKey);
        Assert.notNull(client1);
        
        // Test with minimal OAuth credentials
        var minimalOAuth: Credentials = { 
            clientId: "id", 
            clientSecret: "secret" 
        };
        var client2 = new SpotOnClient(minimalOAuth);
        Assert.notNull(client2);
        
        // Test with both API key and OAuth (should work)
        var bothCredentials: Credentials = {
            apiKey: "valid_api_key_minimum_length",
            clientId: "valid_client_id",
            clientSecret: "valid_client_secret"
        };
        var client3 = new SpotOnClient(bothCredentials);
        Assert.notNull(client3);
    }
    
    /**
     * Test client state after construction
     */
    public function testClientStateAfterConstruction() {
        var client = new SpotOnClient(validApiKeyCredentials);
        
        // Client should be constructed but not necessarily authenticated
        Assert.notNull(client);
        
        // All endpoints should be accessible immediately after construction
        Assert.notNull(client.business);
        Assert.notNull(client.orders);
        Assert.notNull(client.menus);
        Assert.notNull(client.loyalty);
        Assert.notNull(client.reporting);
        Assert.notNull(client.labor);
        Assert.notNull(client.onboarding);
        Assert.notNull(client.webhooks);
    }
    
    /**
     * Test error handling for invalid configurations
     */
    public function testInvalidConfigurationErrorHandling() {
        // Test with completely empty credentials object
        var emptyCredentials: Credentials = {};
        
        // Should not throw during construction
        var client = new SpotOnClient(emptyCredentials);
        Assert.notNull(client);
        
        // But authentication should fail
        Assert.raises(function() {
            client.authenticate();
        }, SpotOnException);
    }
    
    /**
     * Test client with edge case base URLs
     */
    public function testClientWithEdgeCaseBaseUrls() {
        // Test with trailing slash
        var client1 = new SpotOnClient(validApiKeyCredentials, "https://api.spoton.com/");
        Assert.notNull(client1);
        
        // Test with different protocol
        var client2 = new SpotOnClient(validApiKeyCredentials, "http://localhost:8080");
        Assert.notNull(client2);
        
        // Test with empty string (should use default)
        var client3 = new SpotOnClient(validApiKeyCredentials, "");
        Assert.notNull(client3);
    }
}