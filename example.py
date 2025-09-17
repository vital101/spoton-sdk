#!/usr/bin/env python3
"""
SpotOn Python SDK Usage Example

This example demonstrates basic usage of the SpotOn Python SDK,
including client initialization, authentication, and making API calls.

Requirements covered:
- 2.1: SDK compiled to Python provides all core API functionality
- 2.2: Python developer can authenticate with SpotOn's API using provided credentials
- 2.3: API calls return properly typed response objects following Python conventions
- 2.4: Network errors are handled gracefully with appropriate error messages
"""

import sys
import json
from spoton import SpotOnClient
from spoton.errors import SpotOnException, AuthenticationException, NetworkException

def main():
    """
    Main function demonstrating SpotOn SDK usage
    """
    try:
        # Initialize SpotOn client with API key credentials
        # Replace 'your-api-key-here' with your actual SpotOn API key
        credentials = {
            'apiKey': 'your-api-key-here'
        }

        # Create SpotOn client instance
        # Optionally specify a custom base URL (defaults to production API)
        client = SpotOnClient(credentials)

        print("SpotOn Python SDK Example")
        print("=" * 40)

        # Authenticate with the SpotOn API
        print("Authenticating with SpotOn API...")
        if client.authenticate():
            print("✓ Authentication successful")
        else:
            print("✗ Authentication failed")
            return 1

        # Example location ID (replace with your actual location ID)
        # SpotOn location IDs follow the format: BL-XXXX-XXXX-XXXX
        location_id = "BL-1234-5678-9012"

        print(f"\nRetrieving location information for: {location_id}")

        # Get location information
        def handle_location_response(response):
            """
            Callback function to handle the location API response
            """
            if response is None:
                print("✗ No response received")
                return

            try:
                # Parse and display location information
                print("✓ Location retrieved successfully:")
                print(f"  ID: {response.get('id', 'N/A')}")
                print(f"  Name: {response.get('name', 'N/A')}")
                print(f"  Email: {response.get('email', 'N/A')}")
                print(f"  Phone: {response.get('phone', 'N/A')}")

                # Display address information if available
                address = response.get('address')
                if address:
                    print("  Address:")
                    print(f"    {address.get('address_line_1', '')}")
                    if address.get('address_line_2'):
                        print(f"    {address.get('address_line_2')}")
                    print(f"    {address.get('city', '')}, {address.get('state', '')} {address.get('zip', '')}")
                    print(f"    {address.get('country', '')}")

                # Display geolocation if available
                geolocation = response.get('geolocation')
                if geolocation:
                    print(f"  Location: {geolocation.get('latitude', 'N/A')}, {geolocation.get('longitude', 'N/A')}")

                # Display timezone if available
                timezone = response.get('timezone')
                if timezone:
                    print(f"  Timezone: {timezone}")

            except Exception as e:
                print(f"✗ Error parsing location response: {e}")

        # Make the API call to get location information
        client.business.getLocation(location_id, handle_location_response)

        print("\n" + "=" * 40)
        print("Example completed successfully!")

        return 0

    except AuthenticationException as e:
        print(f"✗ Authentication error: {e}")
        print("Please check your API credentials and try again.")
        return 1

    except NetworkException as e:
        print(f"✗ Network error: {e}")
        print("Please check your internet connection and try again.")
        return 1

    except SpotOnException as e:
        print(f"✗ SpotOn API error: {e}")
        if hasattr(e, 'code'):
            print(f"Error code: {e.code}")
        if hasattr(e, 'details'):
            print(f"Details: {e.details}")
        return 1

    except Exception as e:
        print(f"✗ Unexpected error: {e}")
        return 1

def example_with_oauth_credentials():
    """
    Alternative example showing OAuth client credentials authentication
    """
    try:
        # Initialize SpotOn client with OAuth credentials
        credentials = {
            'clientId': 'your-client-id-here',
            'clientSecret': 'your-client-secret-here'
        }

        # Create SpotOn client instance
        client = SpotOnClient(credentials)

        print("OAuth Authentication Example")
        print("=" * 40)

        # Authenticate with OAuth credentials
        print("Authenticating with OAuth credentials...")
        if client.authenticate():
            print("✓ OAuth authentication successful")

            # You can now make API calls as shown in the main example
            print("Client ready for API calls!")
        else:
            print("✗ OAuth authentication failed")

    except Exception as e:
        print(f"✗ OAuth authentication error: {e}")

if __name__ == "__main__":
    """
    Entry point for the example script
    """
    print("SpotOn Python SDK - Usage Examples")
    print()

    # Run the main API key example
    exit_code = main()

    print()
    print("-" * 50)
    print()

    # Show OAuth example (commented out to avoid actual API calls)
    # Uncomment the line below to run the OAuth example
    # example_with_oauth_credentials()

    sys.exit(exit_code)