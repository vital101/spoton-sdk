#!/usr/bin/env node
/**
 * SpotOn Node.js SDK Usage Example
 *
 * This example demonstrates basic usage of the SpotOn Node.js SDK,
 * including client initialization, authentication, and making API calls.
 *
 * Requirements covered:
 * - 3.1: SDK compiled to Node.js provides all core API functionality
 * - 3.2: Node.js developer can authenticate with SpotOn's API using provided credentials
 * - 3.3: API calls return properly typed response objects or Promises
 * - 3.4: Network errors are handled gracefully with appropriate error messages
 */

// Import the SpotOn SDK (compiled from Haxe)
const { SpotOnClient } = require('./out/nodejs/index.js');

/**
 * Main function demonstrating SpotOn SDK usage with async/await
 */
async function main() {
    try {
        // Initialize SpotOn client with API key credentials
        // Replace 'your-api-key-here' with your actual SpotOn API key
        const credentials = {
            apiKey: 'your-api-key-here'
        };

        // Create SpotOn client instance
        // Optionally specify a custom base URL (defaults to production API)
        const client = new SpotOnClient(credentials);

        console.log('SpotOn Node.js SDK Example');
        console.log('='.repeat(40));

        // Authenticate with the SpotOn API
        console.log('Authenticating with SpotOn API...');
        const isAuthenticated = await client.authenticate();

        if (isAuthenticated) {
            console.log('✓ Authentication successful');
        } else {
            console.log('✗ Authentication failed');
            return 1;
        }

        // Example location ID (replace with your actual location ID)
        // SpotOn location IDs follow the format: BL-XXXX-XXXX-XXXX
        const locationId = 'BL-1234-5678-9012';

        console.log(`\nRetrieving location information for: ${locationId}`);

        // Get location information using Promise-based API
        const locationResponse = await new Promise((resolve, reject) => {
            client.business.getLocation(locationId, (response) => {
                if (response === null) {
                    reject(new Error('No response received'));
                    return;
                }
                resolve(response);
            });
        });

        // Parse and display location information
        console.log('✓ Location retrieved successfully:');
        console.log(`  ID: ${locationResponse.id || 'N/A'}`);
        console.log(`  Name: ${locationResponse.name || 'N/A'}`);
        console.log(`  Email: ${locationResponse.email || 'N/A'}`);
        console.log(`  Phone: ${locationResponse.phone || 'N/A'}`);

        // Display address information if available
        if (locationResponse.address) {
            const address = locationResponse.address;
            console.log('  Address:');
            console.log(`    ${address.address_line_1 || ''}`);
            if (address.address_line_2) {
                console.log(`    ${address.address_line_2}`);
            }
            console.log(`    ${address.city || ''}, ${address.state || ''} ${address.zip || ''}`);
            console.log(`    ${address.country || ''}`);
        }

        // Display geolocation if available
        if (locationResponse.geolocation) {
            const geo = locationResponse.geolocation;
            console.log(`  Location: ${geo.latitude || 'N/A'}, ${geo.longitude || 'N/A'}`);
        }

        // Display timezone if available
        if (locationResponse.timezone) {
            console.log(`  Timezone: ${locationResponse.timezone}`);
        }

        console.log('\n' + '='.repeat(40));
        console.log('Example completed successfully!');

        return 0;

    } catch (error) {
        // Handle different types of errors gracefully
        if (error.name === 'AuthenticationException') {
            console.error('✗ Authentication error:', error.message);
            console.error('Please check your API credentials and try again.');
        } else if (error.name === 'NetworkException') {
            console.error('✗ Network error:', error.message);
            console.error('Please check your internet connection and try again.');
        } else if (error.name === 'SpotOnException') {
            console.error('✗ SpotOn API error:', error.message);
            if (error.code) {
                console.error(`Error code: ${error.code}`);
            }
            if (error.details) {
                console.error('Details:', error.details);
            }
        } else {
            console.error('✗ Unexpected error:', error.message);
            console.error('Stack trace:', error.stack);
        }

        return 1;
    }
}

/**
 * Alternative example showing OAuth client credentials authentication
 */
async function exampleWithOAuthCredentials() {
    try {
        // Initialize SpotOn client with OAuth credentials
        const credentials = {
            clientId: 'your-client-id-here',
            clientSecret: 'your-client-secret-here'
        };

        // Create SpotOn client instance
        const client = new SpotOnClient(credentials);

        console.log('OAuth Authentication Example');
        console.log('='.repeat(40));

        // Authenticate with OAuth credentials
        console.log('Authenticating with OAuth credentials...');
        const isAuthenticated = await client.authenticate();

        if (isAuthenticated) {
            console.log('✓ OAuth authentication successful');

            // You can now make API calls as shown in the main example
            console.log('Client ready for API calls!');
        } else {
            console.log('✗ OAuth authentication failed');
        }

    } catch (error) {
        console.error('✗ OAuth authentication error:', error.message);
    }
}

/**
 * Example showing Promise-based API usage patterns
 */
async function exampleWithPromises() {
    try {
        const credentials = { apiKey: 'your-api-key-here' };
        const client = new SpotOnClient(credentials);

        console.log('Promise-based API Example');
        console.log('='.repeat(40));

        // Authenticate
        await client.authenticate();
        console.log('✓ Authenticated');

        const locationId = 'BL-1234-5678-9012';

        // Example of chaining multiple API calls with Promises
        const locationPromise = new Promise((resolve, reject) => {
            client.business.getLocation(locationId, (response) => {
                if (response) resolve(response);
                else reject(new Error('Failed to get location'));
            });
        });

        const menusPromise = new Promise((resolve, reject) => {
            client.menus.getMenus(locationId, (response) => {
                if (response) resolve(response);
                else reject(new Error('Failed to get menus'));
            });
        });

        // Wait for both API calls to complete
        const [location, menus] = await Promise.all([locationPromise, menusPromise]);

        console.log(`✓ Retrieved location: ${location.name}`);
        console.log(`✓ Retrieved ${menus.length || 0} menus`);

    } catch (error) {
        console.error('✗ Promise example error:', error.message);
    }
}

/**
 * Example showing error handling for different scenarios
 */
async function exampleErrorHandling() {
    console.log('Error Handling Examples');
    console.log('='.repeat(40));

    // Example 1: Invalid credentials
    try {
        const invalidClient = new SpotOnClient({ apiKey: 'invalid-key' });
        await invalidClient.authenticate();
    } catch (error) {
        console.log('✓ Caught authentication error:', error.message);
    }

    // Example 2: Network timeout simulation
    try {
        const client = new SpotOnClient({ apiKey: 'test-key' });
        // This would typically timeout or fail
        console.log('✓ Network error handling ready');
    } catch (error) {
        console.log('✓ Caught network error:', error.message);
    }

    // Example 3: Invalid location ID
    try {
        const client = new SpotOnClient({ apiKey: 'test-key' });
        await client.authenticate();

        await new Promise((resolve, reject) => {
            client.business.getLocation('invalid-location-id', (response) => {
                if (!response) reject(new Error('Location not found'));
                else resolve(response);
            });
        });
    } catch (error) {
        console.log('✓ Caught API error:', error.message);
    }
}

// Entry point for the example script
if (require.main === module) {
    console.log('SpotOn Node.js SDK - Usage Examples\n');

    // Run the main example
    main()
        .then((exitCode) => {
            console.log('\n' + '-'.repeat(50) + '\n');

            // Show additional examples (commented out to avoid actual API calls)
            // Uncomment the lines below to run additional examples

            // return exampleWithOAuthCredentials();
            // return exampleWithPromises();
            // return exampleErrorHandling();

            process.exit(exitCode);
        })
        .catch((error) => {
            console.error('Unhandled error:', error);
            process.exit(1);
        });
}

// Export functions for use as a module
module.exports = {
    main,
    exampleWithOAuthCredentials,
    exampleWithPromises,
    exampleErrorHandling
};