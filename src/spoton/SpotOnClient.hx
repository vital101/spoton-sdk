package spoton;

import spoton.auth.Credentials;
import spoton.auth.AuthenticationManager;
import spoton.auth.AuthenticationManagerImpl;
import spoton.http.HTTPClient;
import spoton.http.HTTPClientImpl;
import spoton.endpoints.BusinessEndpoint;
import spoton.endpoints.OrderEndpoint;
import spoton.endpoints.MenuEndpoint;
import spoton.endpoints.LoyaltyEndpoint;
import spoton.endpoints.ReportingEndpoint;
import spoton.endpoints.LaborEndpoint;
import spoton.endpoints.OnboardingEndpoint;
import spoton.endpoints.WebhookEndpoint;
import spoton.errors.SpotOnException;

/**
 * SpotOnClient is the main entry point for the SpotOn SDK.
 * It provides access to all SpotOn API endpoints through a unified interface.
 * 
 * This class serves as the primary interface that developers will interact with
 * across all target platforms (PHP, Python, Node.js).
 */
class SpotOnClient {
    private var auth: AuthenticationManager;
    private var httpClient: HTTPClient;
    
    // Endpoint accessors - public properties for easy access
    public var business: BusinessEndpoint;
    public var orders: OrderEndpoint;
    public var menus: MenuEndpoint;
    public var loyalty: LoyaltyEndpoint;
    public var reporting: ReportingEndpoint;
    public var labor: LaborEndpoint;
    public var onboarding: OnboardingEndpoint;
    public var webhooks: WebhookEndpoint;
    
    /**
     * Creates a new SpotOnClient instance with the provided credentials
     * @param credentials API credentials (API key or OAuth client credentials)
     * @param baseUrl Optional base URL for the SpotOn API (defaults to production API)
     * @throws SpotOnException if credentials are null or invalid
     */
    public function new(credentials: Credentials, ?baseUrl: String) {
        // Validate credentials parameter
        if (credentials == null) {
            throw new SpotOnException("Credentials cannot be null", "INVALID_CREDENTIALS");
        }
        
        // Use default SpotOn API base URL if not provided
        if (baseUrl == null) {
            baseUrl = "https://api.spoton.com";
        }
        
        // Initialize authentication manager
        this.auth = new AuthenticationManagerImpl(credentials);
        
        // Initialize HTTP client with base URL
        this.httpClient = new HTTPClientImpl(baseUrl);
        
        // Initialize all endpoint instances
        initializeEndpoints();
    }
    
    /**
     * Authenticates with the SpotOn API using the provided credentials
     * This method must be called before making any API requests
     * @return true if authentication succeeds
     * @throws SpotOnException if authentication fails
     */
    public function authenticate(): Bool {
        try {
            return auth.authenticate();
        } catch (e: Dynamic) {
            throw new SpotOnException("Authentication failed: " + Std.string(e), "AUTHENTICATION_FAILED", e);
        }
    }
    
    /**
     * Initializes all endpoint instances with the HTTP client and authentication manager
     * This method is called during construction to set up all API endpoints
     */
    private function initializeEndpoints(): Void {
        // Initialize all endpoint instances with shared HTTP client and auth manager
        this.business = new BusinessEndpoint(httpClient, auth);
        this.orders = new OrderEndpoint(httpClient, auth);
        this.menus = new MenuEndpoint(httpClient, auth);
        this.loyalty = new LoyaltyEndpoint(httpClient, auth);
        this.reporting = new ReportingEndpoint(httpClient, auth);
        this.labor = new LaborEndpoint(httpClient, auth);
        this.onboarding = new OnboardingEndpoint(httpClient, auth);
        this.webhooks = new WebhookEndpoint(httpClient, auth);
    }
}