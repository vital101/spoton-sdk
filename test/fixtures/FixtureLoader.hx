package test.fixtures;

import haxe.Json;
import sys.io.File;

/**
 * Utility class for loading JSON fixture files
 * Provides easy access to test data from JSON files
 */
class FixtureLoader {
    
    private static var basePath: String = "test/fixtures/";
    
    /**
     * Load a JSON fixture file and parse it as Dynamic
     * @param path Path to the fixture file relative to test/fixtures/
     * @return Parsed JSON data as Dynamic
     */
    public static function loadJson(path: String): Dynamic {
        var fullPath = basePath + path;
        try {
            var content = File.getContent(fullPath);
            return Json.parse(content);
        } catch (e: Dynamic) {
            throw new Error("Failed to load fixture: " + fullPath + " - " + Std.string(e));
        }
    }
    
    /**
     * Load a business location fixture
     * @return Location fixture data
     */
    public static function loadLocationSuccess(): Dynamic {
        return loadJson("api_responses/business/location_success.json");
    }
    
    /**
     * Load a business liveness fixture
     * @return Liveness fixture data
     */
    public static function loadLivenessSuccess(): Dynamic {
        return loadJson("api_responses/business/liveness_success.json");
    }
    
    /**
     * Load an order fixture
     * @return Order fixture data
     */
    public static function loadOrderSuccess(): Dynamic {
        return loadJson("api_responses/orders/order_success.json");
    }
    
    /**
     * Load a menu fixture
     * @return Menu fixture data
     */
    public static function loadMenuSuccess(): Dynamic {
        return loadJson("api_responses/menus/menu_success.json");
    }
    
    /**
     * Load error response fixtures
     */
    public static function loadNotFoundError(): Dynamic {
        return loadJson("api_responses/errors/not_found.json");
    }
    
    public static function loadUnauthorizedError(): Dynamic {
        return loadJson("api_responses/errors/unauthorized.json");
    }
    
    public static function loadBadRequestError(): Dynamic {
        return loadJson("api_responses/errors/bad_request.json");
    }
    
    public static function loadServerError(): Dynamic {
        return loadJson("api_responses/errors/server_error.json");
    }
    
    public static function loadRateLimitError(): Dynamic {
        return loadJson("api_responses/errors/rate_limit.json");
    }
    
    /**
     * Load authentication fixtures
     */
    public static function loadValidCredentials(): Dynamic {
        return loadJson("auth/valid_credentials.json");
    }
    
    public static function loadInvalidCredentials(): Dynamic {
        return loadJson("auth/invalid_credentials.json");
    }
    
    public static function loadTokens(): Dynamic {
        return loadJson("auth/tokens.json");
    }
    
    /**
     * Load test configuration
     */
    public static function loadTestConfig(): Dynamic {
        return loadJson("config/test_config.json");
    }
    
    /**
     * Get a specific test configuration by environment
     * @param environment Environment name (default, development, production)
     * @return Configuration object for the specified environment
     */
    public static function getTestConfig(environment: String = "default"): Dynamic {
        var config = loadTestConfig();
        return Reflect.field(config, environment);
    }
    
    /**
     * Load and return a JSON fixture as a string (useful for mock responses)
     * @param path Path to the fixture file relative to test/fixtures/
     * @return Raw JSON string content
     */
    public static function loadJsonString(path: String): String {
        var fullPath = basePath + path;
        try {
            return File.getContent(fullPath);
        } catch (e: Dynamic) {
            throw new Error("Failed to load fixture: " + fullPath + " - " + Std.string(e));
        }
    }
    
    /**
     * Create a mock HTTP response object from a fixture
     * @param path Path to the fixture file
     * @param statusCode HTTP status code (default: 200)
     * @return Mock response object compatible with MockHTTPClient
     */
    public static function createMockResponse(path: String, statusCode: Int = 200): Dynamic {
        return {
            statusCode: statusCode,
            headers: new Map<String, String>(),
            body: loadJsonString(path),
            delay: 0,
            shouldFail: false,
            errorType: null
        };
    }
    
    /**
     * Create a mock error response from an error fixture
     * @param errorType Type of error (not_found, unauthorized, bad_request, server_error, rate_limit)
     * @return Mock error response object
     */
    public static function createErrorResponse(errorType: String): Dynamic {
        var statusCode = switch (errorType) {
            case "not_found": 404;
            case "unauthorized": 401;
            case "bad_request": 400;
            case "server_error": 500;
            case "rate_limit": 429;
            default: 500;
        };
        
        return createMockResponse("api_responses/errors/" + errorType + ".json", statusCode);
    }
}

/**
 * Simple error class for fixture loading errors
 */
class Error {
    public var message: String;
    
    public function new(message: String) {
        this.message = message;
    }
    
    public function toString(): String {
        return message;
    }
}