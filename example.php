<?php
/**
 * SpotOn PHP SDK Usage Example
 *
 * This example demonstrates how to initialize the SpotOnClient and make a basic
 * API call to retrieve location information using the PHP target compilation.
 *
 * Requirements covered: 1.1, 1.2, 1.3, 1.4
 */

// Include the generated SpotOn SDK
require_once __DIR__ . '/out/php/index.php';

use spoton\SpotOnClient;

try {
    // Initialize credentials for API authentication
    // Option 1: Using API Key authentication
    $credentials = (object) [
        'apiKey' => 'your-api-key-here'
    ];

    // Option 2: Using OAuth client credentials (uncomment to use)
    /*
    $credentials = (object) [
        'clientId' => 'your-client-id-here',
        'clientSecret' => 'your-client-secret-here'
    ];
    */

    // Create SpotOnClient instance
    // Uses default production API URL: https://api.spoton.com
    $client = new SpotOnClient($credentials);

    // Alternative: Specify custom base URL (e.g., for sandbox testing)
    // $client = new SpotOnClient($credentials, 'https://sandbox-api.spoton.com');

    echo "SpotOn SDK initialized successfully\n";

    // Authenticate with the SpotOn API
    $isAuthenticated = $client->authenticate();

    if ($isAuthenticated) {
        echo "Authentication successful\n";

        // Example location ID (format: BL-XXXX-XXXX-XXXX)
        $locationId = 'BL-1234-5678-9012';

        echo "Fetching location information for: $locationId\n";

        // Make API call to get location information
        $client->business->getLocation($locationId, function($response) use ($locationId) {
            if ($response === null) {
                echo "Error: No response received\n";
                return;
            }

            echo "Location information retrieved successfully:\n";
            echo "Location ID: $locationId\n";

            // Display location details if available
            if (is_object($response) || is_array($response)) {
                echo "Response data:\n";
                print_r($response);
            } else {
                echo "Response: " . $response . "\n";
            }
        });

    } else {
        echo "Authentication failed\n";
    }

} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo "Error Code: " . (method_exists($e, 'getCode') ? $e->getCode() : 'N/A') . "\n";

    // Display additional error details if available (SpotOnException)
    if (method_exists($e, 'details') && $e->details !== null) {
        echo "Error Details:\n";
        print_r($e->details);
    }
}

echo "\nExample completed.\n";
?>