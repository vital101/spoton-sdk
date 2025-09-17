# SpotOn Haxe SDK

A cross-platform SDK for SpotOn's Central API, written in Haxe and compiled to PHP, Python, and Node.js. This SDK provides a unified interface to interact with SpotOn's restaurant management and point-of-sale services across multiple programming environments.

## Features

- **Cross-Platform**: Single codebase compiles to PHP, Python, and Node.js
- **Type-Safe**: Strongly-typed models and interfaces
- **Comprehensive API Coverage**: Support for all SpotOn Central API endpoints
- **Automatic Authentication**: Built-in token management and refresh
- **Error Handling**: Consistent error handling across all platforms
- **Easy Integration**: Simple installation and setup for each target platform

## Supported Platforms

- **PHP** 7.4+ with Composer support
- **Python** 3.6+ with pip support
- **Node.js** 14+ with npm support

## API Coverage

The SDK provides access to all major SpotOn API endpoints:

- **Business**: Location information and liveness checks
- **Orders**: Order submission, proposal, and cancellation
- **Menus**: Menu items, categories, modifiers, and pricing
- **Loyalty**: Customer management, points, and rewards
- **Reporting**: Historical order data and analytics
- **Labor**: Employee management and time tracking (SpotOn Express only)
- **Onboarding**: OAuth2 location authorization
- **Webhooks**: Event handling and signature validation

## Installation

### Prerequisites

1. **Haxe 4.2+** - Install from [haxe.org](https://haxe.org/download/)
2. **haxelib** - Comes with Haxe installation

### Building from Source

```bash
# Clone the repository
git clone https://github.com/spoton/spoton-haxe-sdk.git
cd spoton-haxe-sdk

# Install Haxe dependencies
haxelib install haxe-concurrent

# Build for all platforms
haxe build-php.hxml      # Builds PHP version to out/php/
haxe build-python.hxml   # Builds Python version to out/python/
haxe build-nodejs.hxml   # Builds Node.js version to out/nodejs/
```

### Platform-Specific Installation

#### PHP

```bash
# After building, include in your PHP project
require_once 'path/to/spoton-haxe-sdk/out/php/index.php';

# Or via Composer (when published)
composer require spoton/spoton-sdk
```

#### Python

```bash
# After building, install locally
cd out/python
pip install .

# Or via pip (when published)
pip install spoton-sdk
```

#### Node.js

```bash
# After building, install locally
npm install ./out/nodejs/

# Or via npm (when published)
npm install spoton-sdk
```

## Quick Start

### Authentication

SpotOn SDK supports two authentication methods:

1. **API Key Authentication** (recommended for server-to-server)
2. **OAuth 2.0 Client Credentials** (for applications)

### PHP Usage

```php
<?php
require_once 'vendor/autoload.php'; // or direct include

use spoton\SpotOnClient;

try {
    // Initialize with API key
    $credentials = (object) [
        'apiKey' => 'your-api-key-here'
    ];

    $client = new SpotOnClient($credentials);

    // Authenticate
    if ($client->authenticate()) {
        echo "Authentication successful!\n";

        // Get location information
        $locationId = 'BL-1234-5678-9012';
        $client->business->getLocation($locationId, function($location) {
            echo "Location: " . $location->name . "\n";
            echo "Address: " . $location->address->city . ", " . $location->address->state . "\n";
        });
    }

} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
```

### Python Usage

```python
from spoton import SpotOnClient
from spoton.errors import SpotOnException

try:
    # Initialize with API key
    credentials = {
        'apiKey': 'your-api-key-here'
    }

    client = SpotOnClient(credentials)

    # Authenticate
    if client.authenticate():
        print("Authentication successful!")

        # Get location information
        location_id = 'BL-1234-5678-9012'

        def handle_location(location):
            print(f"Location: {location['name']}")
            print(f"Address: {location['address']['city']}, {location['address']['state']}")

        client.business.getLocation(location_id, handle_location)

except SpotOnException as e:
    print(f"SpotOn API Error: {e}")
except Exception as e:
    print(f"Error: {e}")
```

### Node.js Usage

```javascript
const { SpotOnClient } = require('spoton-sdk');

async function main() {
    try {
        // Initialize with API key
        const credentials = {
            apiKey: 'your-api-key-here'
        };

        const client = new SpotOnClient(credentials);

        // Authenticate
        const isAuthenticated = await client.authenticate();
        if (isAuthenticated) {
            console.log('Authentication successful!');

            // Get location information
            const locationId = 'BL-1234-5678-9012';

            const location = await new Promise((resolve, reject) => {
                client.business.getLocation(locationId, (response) => {
                    if (response) resolve(response);
                    else reject(new Error('Failed to get location'));
                });
            });

            console.log(`Location: ${location.name}`);
            console.log(`Address: ${location.address.city}, ${location.address.state}`);
        }

    } catch (error) {
        console.error('Error:', error.message);
    }
}

main();
```

## API Examples

### Working with Orders

```javascript
// Submit a new order
const orderData = {
    external_reference_id: 'order-123',
    location_id: 'BL-1234-5678-9012',
    line_items: [
        {
            item_id: 'item-456',
            name: 'Cheeseburger',
            quantity: 2,
            price: 1299 // in cents
        }
    ],
    customer: {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        phone: '+12345678901'
    },
    fulfillment: {
        type: 'FULFILLMENT_TYPE_PICKUP',
        schedule_type: 'ASAP'
    }
};

client.orders.submitOrder('BL-1234-5678-9012', orderData, (response) => {
    console.log('Order submitted:', response.id);
});
```

### Working with Menus

```python
# Get all menus for a location
def handle_menus(menus):
    for menu in menus:
        print(f"Menu: {menu['name']} (Active: {menu['active']})")

client.menus.getMenus(location_id, handle_menus)

# Get menu items
def handle_menu_items(items):
    for item in items:
        print(f"Item: {item['name']} - ${item['price']/100:.2f}")

client.menus.getMenuItems(location_id, menu_id, handle_menu_items)
```

### Working with Customers

```php
// Upsert a customer in the loyalty program
$customerData = (object) [
    'email' => 'customer@example.com',
    'phone' => '+12345678901',
    'full_name' => 'Jane Smith'
];

$client->loyalty->upsertCustomer($locationId, $customerData, function($customer) {
    echo "Customer ID: " . $customer->id . "\n";
    echo "Points Available: " . $customer->points_available . "\n";
});
```

## Error Handling

The SDK provides consistent error handling across all platforms:

### Error Types

- **`SpotOnException`**: Base exception for all SDK errors
- **`AuthenticationException`**: Authentication and authorization failures
- **`NetworkException`**: Network connectivity issues
- **`APIException`**: API-specific errors (4xx, 5xx responses)

### Example Error Handling

```javascript
try {
    await client.authenticate();
} catch (error) {
    if (error.name === 'AuthenticationException') {
        console.error('Invalid credentials:', error.message);
    } else if (error.name === 'NetworkException') {
        console.error('Network error:', error.message);
    } else if (error.name === 'APIException') {
        console.error('API error:', error.message, 'Status:', error.httpStatus);
    }
}
```

## Configuration

### Client Configuration Options

```javascript
const config = {
    baseUrl: 'https://api.spoton.com',  // API base URL
    timeout: 30000,                     // Request timeout in ms
    retryAttempts: 3,                   // Number of retry attempts
    debugMode: false,                   // Enable debug logging
    customHeaders: {                    // Additional headers
        'User-Agent': 'MyApp/1.0'
    }
};

const client = new SpotOnClient(credentials, config);
```

### Environment Variables

You can also configure the SDK using environment variables:

```bash
export SPOTON_API_KEY="your-api-key-here"
export SPOTON_BASE_URL="https://sandbox-api.spoton.com"  # For testing
export SPOTON_DEBUG="true"  # Enable debug mode
```

## Testing

The SDK includes a comprehensive test suite built with Haxe's utest framework, covering all core functionality including authentication, HTTP clients, endpoints, models, and utilities.

### Running Tests

```bash
# Run the complete test suite
haxe build-test.hxml

# This will:
# 1. Compile all test files
# 2. Execute tests using the Neko target
# 3. Display test results with pass/fail status
```

### Test Structure

The test suite is organized into several categories:

- **Core Tests**: `SpotOnClientTest` - Main client functionality
- **Authentication**: `AuthenticationManagerTest`, `CredentialsTest`
- **HTTP Layer**: `HTTPClientTest`, `ResponseTest`
- **Endpoints**: Tests for all API endpoints (Business, Orders, Menus, etc.)
- **Models**: Comprehensive model validation and serialization tests
- **Utilities**: Helper functions and data transformation tests
- **Error Handling**: Exception and error response tests

### Test Configuration

Tests use mock implementations to avoid making real API calls:

- `MockAuthenticationManager` - Simulates authentication flows
- `MockHTTPClient` - Provides controlled HTTP responses
- Test fixtures in `test/fixtures/` - Sample data and helpers

### Sandbox Environment

For integration testing with real API calls, use SpotOn's sandbox environment:

```javascript
const client = new SpotOnClient(credentials, {
    baseUrl: 'https://sandbox-api.spoton.com'
});
```

## Continuous Integration

[![CI](https://github.com/spoton/spoton-haxe-sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/spoton/spoton-haxe-sdk/actions/workflows/ci.yml)
[![Tests](https://img.shields.io/github/actions/workflow/status/spoton/spoton-haxe-sdk/ci.yml?label=tests)](https://github.com/spoton/spoton-haxe-sdk/actions/workflows/ci.yml)

This project uses GitHub Actions for continuous integration to ensure code quality and prevent regressions. The CI system automatically runs tests on every push and pull request.

### CI/CD Features

- **Automated Testing**: Tests run automatically on every push and pull request
- **Multi-Version Support**: Tests against Haxe 4.2.x and 4.3.x for compatibility
- **Branch Protection**: Main branch is protected and requires passing tests before merge
- **Dependency Caching**: Faster builds through intelligent dependency caching
- **Test Reporting**: Detailed test results and coverage information
- **Status Checks**: Clear pass/fail indicators on commits and pull requests

### Workflow Triggers

The CI workflow runs automatically when:

- Code is pushed to any branch
- A pull request is opened or updated
- Manual workflow dispatch is triggered

### Test Matrix

Tests run against multiple Haxe versions to ensure compatibility:

- **Haxe 4.2.5** - Stable LTS version
- **Haxe 4.3.4** - Latest stable version

All versions must pass for the build to be considered successful.

### Branch Protection Rules

The main branch is protected with the following requirements:

- **Pull Request Required**: Direct pushes to main are not allowed
- **Status Checks Required**: All CI tests must pass before merging
- **Up-to-date Branch Required**: Branches must be current with main before merging
- **Administrator Override**: Administrators can bypass restrictions if needed

### Setting Up Branch Protection

To configure branch protection rules for your fork:

1. Go to your repository's **Settings** → **Branches**
2. Click **Add rule** for the `main` branch
3. Enable the following options:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Include administrators (optional)
4. In the status checks section, add:
   - `CI / test (4.2.5)`
   - `CI / test (4.3.4)`
5. Save the protection rule

For detailed setup instructions, see [Branch Protection Setup Guide](.github/docs/BRANCH_PROTECTION_SETUP.md).

### Troubleshooting CI Issues

#### Common Issues and Solutions

**Build Fails with "Haxe not found"**
```bash
# Solution: Ensure the setup-haxe action is properly configured
- uses: krdlab/setup-haxe@v1
  with:
    haxe-version: ${{ matrix.haxe-version }}
```

**Dependencies fail to install**
```bash
# Check if haxelib.json is valid
haxelib install --always

# Clear cache if dependencies are corrupted
# Go to Actions → Caches and delete relevant cache entries
```

**Tests pass locally but fail in CI**
- Check for platform-specific differences (line endings, file paths)
- Ensure all test dependencies are listed in haxelib.json
- Verify test files are included in the repository

**Cache issues causing slow builds**
- Cache is automatically managed based on haxelib.json changes
- Manual cache clearing: Go to repository Settings → Actions → Caches
- Cache keys are based on `haxelib-${{ hashFiles('haxelib.json') }}`

**Status checks not appearing on PRs**
- Verify branch protection rules are configured correctly
- Check that workflow file is in `.github/workflows/ci.yml`
- Ensure workflow has proper permissions in repository settings

#### Getting Help

If you encounter CI issues:

1. **Check the workflow logs**: Click on the failed status check for detailed error information
2. **Review recent changes**: Compare with the last successful build
3. **Test locally**: Run `haxe build-test.hxml` to reproduce issues locally
4. **Check dependencies**: Ensure all required libraries are in haxelib.json

For detailed troubleshooting steps, see the [CI Troubleshooting Guide](.github/docs/CI_TROUBLESHOOTING.md).

For persistent issues, please [open an issue](https://github.com/spoton/spoton-haxe-sdk/issues) with:
- Link to the failed workflow run
- Error messages from the logs
- Steps to reproduce locally

### Performance Optimization

The CI system includes several optimizations for faster builds:

- **Dependency Caching**: Haxelib dependencies are cached between runs
- **Parallel Execution**: Different Haxe versions run in parallel
- **Incremental Builds**: Only changed components are rebuilt when possible

For more details, see [Performance Optimization Guide](.github/docs/PERFORMANCE_OPTIMIZATION.md).

## API Documentation

For detailed API documentation, visit:

- **SpotOn Central API Documentation**: [https://docs.spoton.com/central-api](https://docs.spoton.com/central-api)
- **Authentication Guide**: [https://docs.spoton.com/central-api/authentication](https://docs.spoton.com/central-api/authentication)
- **Webhook Documentation**: [https://docs.spoton.com/central-api/webhooks](https://docs.spoton.com/central-api/webhooks)

## Examples

Complete working examples are available in the repository:

- **PHP Example**: [`example.php`](example.php)
- **Python Example**: [`example.py`](example.py)
- **Node.js Example**: [`example.js`](example.js)

## Requirements

### Platform Requirements

#### PHP
- PHP 7.4 or higher
- cURL extension
- JSON extension
- OpenSSL extension (for HTTPS)

#### Python
- Python 3.6 or higher
- `requests` library (automatically installed)
- `json` library (built-in)

#### Node.js
- Node.js 14 or higher
- Built-in `https` and `querystring` modules

### SpotOn API Requirements

- Valid SpotOn API credentials (API key or OAuth client credentials)
- Authorized location access
- Network connectivity to SpotOn's API endpoints

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes in the Haxe source files (`src/spoton/`)
4. Test across all platforms
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Setup

```bash
# Install development dependencies
haxelib install haxe-concurrent

# Build all targets
make build

# Run tests
make test

# Generate documentation
make docs
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Documentation**: [https://docs.spoton.com](https://docs.spoton.com)
- **API Support**: [api-support@spoton.com](mailto:api-support@spoton.com)
- **Issues**: [GitHub Issues](https://github.com/spoton/spoton-haxe-sdk/issues)

## Changelog

### v0.1.0 (Initial Release)
- Cross-platform SDK for PHP, Python, and Node.js
- Complete SpotOn Central API coverage
- Authentication and token management
- Comprehensive error handling
- Type-safe models and interfaces
- Working examples for all platforms

---

**SpotOn Haxe SDK** - Bringing SpotOn's powerful API to your favorite programming language.