package test.spoton.auth;

import spoton.auth.AuthenticationManager;
import spoton.auth.Credentials;

/**
 * Mock authentication manager for testing purposes
 * Provides configurable authentication states and token generation
 */
class MockAuthenticationManager implements AuthenticationManager {
    
    /**
     * Whether authentication should succeed
     */
    public var shouldAuthenticate: Bool = true;
    
    /**
     * Mock authentication token
     */
    public var mockToken: String = "mock_token_12345";
    
    /**
     * Mock API key
     */
    public var mockApiKey: String = "mock_api_key_67890";
    
    /**
     * Authentication headers to return
     */
    public var mockAuthHeaders: Map<String, String>;
    
    /**
     * Number of authentication attempts made
     */
    public var authenticationAttempts: Int = 0;
    
    /**
     * History of authentication attempts
     */
    public var authenticationHistory: Array<AuthAttempt>;
    
    /**
     * Whether the manager is currently authenticated
     */
    public var isAuthenticated: Bool = false;
    
    /**
     * Credentials used for authentication
     */
    public var credentials: Credentials;
    
    /**
     * Delay for authentication operations (milliseconds)
     */
    public var authDelay: Int = 0;
    
    /**
     * Whether to simulate authentication timeout
     */
    public var simulateTimeout: Bool = false;
    
    /**
     * Authentication session expiry time (timestamp)
     */
    public var sessionExpiry: Float = 0;
    
    /**
     * Session duration in milliseconds
     */
    public var sessionDuration: Int = 3600000; // 1 hour default
    
    /**
     * Number of times getAuthHeaders was called
     */
    public var getAuthHeadersCalls: Int = 0;
    
    public function new(?credentials: Credentials) {
        this.credentials = credentials;
        mockAuthHeaders = new Map<String, String>();
        authenticationHistory = new Array<AuthAttempt>();
        
        // Set default auth headers
        mockAuthHeaders.set("Authorization", "Bearer " + mockToken);
        mockAuthHeaders.set("X-API-Key", mockApiKey);
    }
    
    /**
     * Set custom credentials
     */
    public function setCredentials(credentials: Credentials): Void {
        this.credentials = credentials;
    }
    
    /**
     * Configure authentication to succeed or fail
     */
    public function setAuthenticationResult(shouldSucceed: Bool): Void {
        shouldAuthenticate = shouldSucceed;
    }
    
    /**
     * Set custom authentication token
     */
    public function setMockToken(token: String): Void {
        mockToken = token;
        mockAuthHeaders.set("Authorization", "Bearer " + token);
    }
    
    /**
     * Set custom API key
     */
    public function setMockApiKey(apiKey: String): Void {
        mockApiKey = apiKey;
        mockAuthHeaders.set("X-API-Key", apiKey);
    }
    
    /**
     * Set custom authentication headers
     */
    public function setMockAuthHeaders(headers: Map<String, String>): Void {
        mockAuthHeaders = headers;
    }
    
    /**
     * Add a custom authentication header
     */
    public function addAuthHeader(name: String, value: String): Void {
        mockAuthHeaders.set(name, value);
    }
    
    /**
     * Clear authentication history
     */
    public function clearAuthenticationHistory(): Void {
        authenticationHistory = new Array<AuthAttempt>();
        authenticationAttempts = 0;
    }
    
    /**
     * Get the last authentication attempt
     */
    public function getLastAuthAttempt(): AuthAttempt {
        return authenticationHistory.length > 0 ? authenticationHistory[authenticationHistory.length - 1] : null;
    }
    
    /**
     * Simulate session expiry
     */
    public function expireSession(): Void {
        sessionExpiry = Date.now().getTime() - 1000; // Expired 1 second ago
        isAuthenticated = false;
    }
    
    /**
     * Check if session is expired
     */
    public function isSessionExpired(): Bool {
        return sessionExpiry > 0 && Date.now().getTime() > sessionExpiry;
    }
    
    /**
     * Validate credentials format
     */
    public function validateCredentials(): Bool {
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
    
    public function authenticate(): Bool {
        authenticationAttempts++;
        
        var attempt: AuthAttempt = {
            timestamp: Date.now().getTime(),
            success: false,
            credentials: credentials,
            errorMessage: null
        };
        
        // Simulate timeout
        if (simulateTimeout) {
            attempt.errorMessage = "Authentication timeout";
            authenticationHistory.push(attempt);
            return false;
        }
        
        // Validate credentials
        if (!validateCredentials()) {
            attempt.errorMessage = "Invalid credentials format";
            authenticationHistory.push(attempt);
            return false;
        }
        
        // Check if authentication should succeed
        if (!shouldAuthenticate) {
            attempt.errorMessage = "Authentication failed";
            authenticationHistory.push(attempt);
            isAuthenticated = false;
            return false;
        }
        
        // Successful authentication
        attempt.success = true;
        isAuthenticated = true;
        sessionExpiry = Date.now().getTime() + sessionDuration;
        authenticationHistory.push(attempt);
        
        return true;
    }
    
    public function getAuthHeaders(): Map<String, String> {
        getAuthHeadersCalls++;
        
        // Check if session is expired
        if (isSessionExpired()) {
            isAuthenticated = false;
            return new Map<String, String>();
        }
        
        // Return empty headers if not authenticated
        if (!isAuthenticated) {
            return new Map<String, String>();
        }
        
        // Return configured auth headers
        var headers = new Map<String, String>();
        for (key in mockAuthHeaders.keys()) {
            headers.set(key, mockAuthHeaders.get(key));
        }
        
        return headers;
    }
    
    /**
     * Force authentication state (for testing)
     */
    public function setAuthenticationState(authenticated: Bool): Void {
        isAuthenticated = authenticated;
        if (authenticated) {
            sessionExpiry = Date.now().getTime() + sessionDuration;
        } else {
            sessionExpiry = 0;
        }
    }
    
    /**
     * Get authentication statistics
     */
    public function getAuthStats(): AuthStats {
        var successfulAttempts = 0;
        var failedAttempts = 0;
        
        for (attempt in authenticationHistory) {
            if (attempt.success) {
                successfulAttempts++;
            } else {
                failedAttempts++;
            }
        }
        
        return {
            totalAttempts: authenticationAttempts,
            successfulAttempts: successfulAttempts,
            failedAttempts: failedAttempts,
            isCurrentlyAuthenticated: isAuthenticated,
            sessionExpiry: sessionExpiry
        };
    }
}

/**
 * Authentication attempt record
 */
typedef AuthAttempt = {
    timestamp: Float,
    success: Bool,
    credentials: Credentials,
    errorMessage: String
}

/**
 * Authentication statistics
 */
typedef AuthStats = {
    totalAttempts: Int,
    successfulAttempts: Int,
    failedAttempts: Int,
    isCurrentlyAuthenticated: Bool,
    sessionExpiry: Float
}