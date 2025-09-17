package test.fixtures;

import spoton.models.business.Location;
import spoton.models.orders.Order;
import spoton.models.orders.OrderItem;
import spoton.models.orders.OrderState;
import spoton.models.orders.OrderSource;
import spoton.models.orders.OrderCustomer;
import spoton.models.orders.OrderFulfillment;
import spoton.models.orders.OrderTotals;
import spoton.models.menus.Menu;
import spoton.models.common.Address;
import spoton.models.common.Geolocation;
import spoton.auth.Credentials;

/**
 * Main test data builder class providing fluent API for creating test objects
 * Uses builder pattern to create consistent, customizable test data
 */
class TestDataBuilder {
    
    /**
     * Create a new LocationBuilder for building Location test objects
     */
    public static function location(): LocationBuilder {
        return new LocationBuilder();
    }
    
    /**
     * Create a new OrderBuilder for building Order test objects
     */
    public static function order(): OrderBuilder {
        return new OrderBuilder();
    }
    
    /**
     * Create a new MenuBuilder for building Menu test objects
     */
    public static function menu(): MenuBuilder {
        return new MenuBuilder();
    }
    
    /**
     * Create a new CredentialsBuilder for building Credentials test objects
     */
    public static function credentials(): CredentialsBuilder {
        return new CredentialsBuilder();
    }
    
    /**
     * Create a new AddressBuilder for building Address test objects
     */
    public static function address(): AddressBuilder {
        return new AddressBuilder();
    }
    
    /**
     * Create a new OrderItemBuilder for building OrderItem test objects
     */
    public static function orderItem(): OrderItemBuilder {
        return new OrderItemBuilder();
    }
}

/**
 * Builder for Location objects with default values and fluent API
 */
class LocationBuilder {
    private var location: Location;
    
    public function new() {
        location = {
            id: "BL-TEST-1234-5678-9012",
            name: "Test Restaurant",
            email: "test@restaurant.com",
            phone: "+1-555-0123",
            address: TestDataBuilder.address().build(),
            geolocation: { latitude: 37.7749, longitude: -122.4194 },
            timezone: "America/Los_Angeles"
        };
    }
    
    public function withId(id: String): LocationBuilder {
        location.id = id;
        return this;
    }
    
    public function withName(name: String): LocationBuilder {
        location.name = name;
        return this;
    }
    
    public function withEmail(email: String): LocationBuilder {
        location.email = email;
        return this;
    }
    
    public function withPhone(phone: String): LocationBuilder {
        location.phone = phone;
        return this;
    }
    
    public function withAddress(address: Address): LocationBuilder {
        location.address = address;
        return this;
    }
    
    public function withGeolocation(lat: Float, lng: Float): LocationBuilder {
        location.geolocation = { latitude: lat, longitude: lng };
        return this;
    }
    
    public function withTimezone(timezone: String): LocationBuilder {
        location.timezone = timezone;
        return this;
    }
    
    public function build(): Location {
        return location;
    }
}

/**
 * Builder for Address objects with default values and fluent API
 */
class AddressBuilder {
    private var address: Address;
    
    public function new() {
        address = {
            address_line_1: "123 Test Street",
            city: "Test City",
            state: "CA",
            zip: "12345",
            country: "US"
        };
    }
    
    public function withAddressLine1(addressLine1: String): AddressBuilder {
        address.address_line_1 = addressLine1;
        return this;
    }
    
    public function withCity(city: String): AddressBuilder {
        address.city = city;
        return this;
    }
    
    public function withState(state: String): AddressBuilder {
        address.state = state;
        return this;
    }
    
    public function withZip(zip: String): AddressBuilder {
        address.zip = zip;
        return this;
    }
    
    public function withCountry(country: String): AddressBuilder {
        address.country = country;
        return this;
    }
    
    public function build(): Address {
        return address;
    }
}

/**
 * Builder for Credentials objects with default values and fluent API
 */
class CredentialsBuilder {
    private var credentials: Credentials;
    
    public function new() {
        credentials = {};
    }
    
    public function withApiKey(apiKey: String): CredentialsBuilder {
        credentials.apiKey = apiKey;
        return this;
    }
    
    public function withOAuth(clientId: String, clientSecret: String): CredentialsBuilder {
        credentials.clientId = clientId;
        credentials.clientSecret = clientSecret;
        return this;
    }
    
    public function withClientId(clientId: String): CredentialsBuilder {
        credentials.clientId = clientId;
        return this;
    }
    
    public function withClientSecret(clientSecret: String): CredentialsBuilder {
        credentials.clientSecret = clientSecret;
        return this;
    }
    
    public function validApiKey(): CredentialsBuilder {
        credentials.apiKey = "sk_test_1234567890abcdef1234567890abcdef12345678";
        return this;
    }
    
    public function validOAuth(): CredentialsBuilder {
        credentials.clientId = "client_test_12345678901234567890";
        credentials.clientSecret = "secret_test_abcdef1234567890abcdef1234567890";
        return this;
    }
    
    public function shortApiKey(): CredentialsBuilder {
        credentials.apiKey = "short";
        return this;
    }
    
    public function emptyApiKey(): CredentialsBuilder {
        credentials.apiKey = "";
        return this;
    }
    
    public function build(): Credentials {
        return credentials;
    }
}
/*
*
 * Builder for Menu objects with default values and fluent API
 */
class MenuBuilder {
    private var menu: Menu;
    
    public function new() {
        menu = {
            id: "MENU-TEST-001",
            location_id: "BL-TEST-1234-5678-9012",
            name: "Test Menu",
            active: true,
            created_at: Date.fromString("2023-01-15 08:00:00")
        };
    }
    
    public function withId(id: String): MenuBuilder {
        menu.id = id;
        return this;
    }
    
    public function withLocationId(locationId: String): MenuBuilder {
        menu.location_id = locationId;
        return this;
    }
    
    public function withName(name: String): MenuBuilder {
        menu.name = name;
        return this;
    }
    
    public function withActive(active: Bool): MenuBuilder {
        menu.active = active;
        return this;
    }
    
    public function withCreatedAt(createdAt: Date): MenuBuilder {
        menu.created_at = createdAt;
        return this;
    }
    
    public function inactive(): MenuBuilder {
        menu.active = false;
        return this;
    }
    
    public function build(): Menu {
        return menu;
    }
}

/**
 * Builder for OrderItem objects with default values and fluent API
 */
class OrderItemBuilder {
    private var orderItem: OrderItem;
    
    public function new() {
        orderItem = {
            line_id: "LI-TEST-001",
            item_id: "ITEM-TEST-001",
            name: "Test Item",
            quantity: 1,
            price: 999
        };
    }
    
    public function withLineId(lineId: String): OrderItemBuilder {
        orderItem.line_id = lineId;
        return this;
    }
    
    public function withItemId(itemId: String): OrderItemBuilder {
        orderItem.item_id = itemId;
        return this;
    }
    
    public function withName(name: String): OrderItemBuilder {
        orderItem.name = name;
        return this;
    }
    
    public function withQuantity(quantity: Int): OrderItemBuilder {
        orderItem.quantity = quantity;
        return this;
    }
    
    public function withPrice(price: Int): OrderItemBuilder {
        orderItem.price = price;
        return this;
    }
    
    public function build(): OrderItem {
        return orderItem;
    }
}

/**
 * Builder for Order objects with default values and fluent API
 */
class OrderBuilder {
    private var order: Order;
    
    public function new() {
        order = {
            id: "ORD-TEST-001234",
            external_reference_id: "EXT-TEST-789",
            location_id: "BL-TEST-1234-5678-9012",
            line_items: [TestDataBuilder.orderItem().build()],
            state: ORDER_STATE_OPEN,
            source: {
                channel: "test",
                platform: "test",
                version: "1.0"
            },
            customer: {
                id: "CUST-TEST-5678",
                name: "Test Customer",
                email: "test@customer.com",
                phone: "+1-555-0199"
            },
            fulfillment: {
                type: "pickup",
                requested_time: "2023-12-01T12:00:00Z",
                estimated_time: "2023-12-01T12:15:00Z"
            },
            totals: {
                subtotal: 999,
                tax: 90,
                tip: 150,
                total: 1239
            },
            menu_id: "MENU-TEST-001"
        };
    }
    
    public function withId(id: String): OrderBuilder {
        order.id = id;
        return this;
    }
    
    public function withExternalReferenceId(externalReferenceId: String): OrderBuilder {
        order.external_reference_id = externalReferenceId;
        return this;
    }
    
    public function withLocationId(locationId: String): OrderBuilder {
        order.location_id = locationId;
        return this;
    }
    
    public function withLineItems(lineItems: Array<OrderItem>): OrderBuilder {
        order.line_items = lineItems;
        return this;
    }
    
    public function addLineItem(lineItem: OrderItem): OrderBuilder {
        order.line_items.push(lineItem);
        return this;
    }
    
    public function withState(state: OrderState): OrderBuilder {
        order.state = state;
        return this;
    }
    
    public function withMenuId(menuId: String): OrderBuilder {
        order.menu_id = menuId;
        return this;
    }
    
    public function closed(): OrderBuilder {
        order.state = ORDER_STATE_CLOSED;
        return this;
    }
    
    public function canceled(): OrderBuilder {
        order.state = ORDER_STATE_CANCELED;
        return this;
    }
    
    public function draft(): OrderBuilder {
        order.state = ORDER_STATE_DRAFT;
        return this;
    }
    
    public function build(): Order {
        return order;
    }
}