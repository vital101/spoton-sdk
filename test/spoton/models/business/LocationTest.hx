package test.spoton.models.business;

import utest.Test;
import utest.Assert;
import spoton.models.business.Location;
import spoton.models.common.Address;
import spoton.models.common.Geolocation;

/**
 * Test suite for Location model
 * Tests model structure, property access, and nested object handling
 */
class LocationTest extends Test {
    
    function testLocationCreation() {
        var address: Address = {
            address_line_1: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zip: "94105",
            country: "US"
        };
        
        var geolocation: Geolocation = {
            latitude: 37.7749,
            longitude: -122.4194
        };
        
        var location: Location = {
            id: "loc_123456",
            name: "Downtown Cafe",
            email: "contact@downtowncafe.com",
            phone: "+1-555-123-4567",
            address: address,
            geolocation: geolocation,
            timezone: "America/Los_Angeles"
        };
        
        Assert.equals("loc_123456", location.id);
        Assert.equals("Downtown Cafe", location.name);
        Assert.equals("contact@downtowncafe.com", location.email);
        Assert.equals("+1-555-123-4567", location.phone);
        Assert.equals("America/Los_Angeles", location.timezone);
        
        // Test nested address
        Assert.equals("123 Main St", location.address.address_line_1);
        Assert.equals("San Francisco", location.address.city);
        Assert.equals("CA", location.address.state);
        Assert.equals("94105", location.address.zip);
        Assert.equals("US", location.address.country);
        
        // Test nested geolocation
        Assert.floatEquals(37.7749, location.geolocation.latitude);
        Assert.floatEquals(-122.4194, location.geolocation.longitude);
    }
    
    function testLocationWithEmptyValues() {
        var address: Address = {
            address_line_1: "",
            city: "",
            state: "",
            zip: "",
            country: ""
        };
        
        var geolocation: Geolocation = {
            latitude: 0.0,
            longitude: 0.0
        };
        
        var location: Location = {
            id: "",
            name: "",
            email: "",
            phone: "",
            address: address,
            geolocation: geolocation,
            timezone: ""
        };
        
        Assert.equals("", location.id);
        Assert.equals("", location.name);
        Assert.equals("", location.email);
        Assert.equals("", location.phone);
        Assert.equals("", location.timezone);
    }
    
    function testLocationPropertyModification() {
        var address: Address = {
            address_line_1: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zip: "94105",
            country: "US"
        };
        
        var geolocation: Geolocation = {
            latitude: 37.7749,
            longitude: -122.4194
        };
        
        var location: Location = {
            id: "loc_123456",
            name: "Downtown Cafe",
            email: "contact@downtowncafe.com",
            phone: "+1-555-123-4567",
            address: address,
            geolocation: geolocation,
            timezone: "America/Los_Angeles"
        };
        
        // Modify properties
        location.id = "loc_789012";
        location.name = "Uptown Bistro";
        location.email = "info@uptownbistro.com";
        location.phone = "+1-555-987-6543";
        location.timezone = "America/New_York";
        
        Assert.equals("loc_789012", location.id);
        Assert.equals("Uptown Bistro", location.name);
        Assert.equals("info@uptownbistro.com", location.email);
        Assert.equals("+1-555-987-6543", location.phone);
        Assert.equals("America/New_York", location.timezone);
    }
    
    function testLocationNestedObjectModification() {
        var address: Address = {
            address_line_1: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zip: "94105",
            country: "US"
        };
        
        var geolocation: Geolocation = {
            latitude: 37.7749,
            longitude: -122.4194
        };
        
        var location: Location = {
            id: "loc_123456",
            name: "Downtown Cafe",
            email: "contact@downtowncafe.com",
            phone: "+1-555-123-4567",
            address: address,
            geolocation: geolocation,
            timezone: "America/Los_Angeles"
        };
        
        // Modify nested address
        location.address.address_line_1 = "456 Oak Ave";
        location.address.city = "Los Angeles";
        location.address.zip = "90210";
        
        Assert.equals("456 Oak Ave", location.address.address_line_1);
        Assert.equals("Los Angeles", location.address.city);
        Assert.equals("90210", location.address.zip);
        
        // Modify nested geolocation
        location.geolocation.latitude = 34.0522;
        location.geolocation.longitude = -118.2437;
        
        Assert.floatEquals(34.0522, location.geolocation.latitude);
        Assert.floatEquals(-118.2437, location.geolocation.longitude);
    }
    
    function testLocationWithInternationalData() {
        var address: Address = {
            address_line_1: "123 Rue de la Paix",
            city: "Paris",
            state: "Île-de-France",
            zip: "75001",
            country: "FR"
        };
        
        var geolocation: Geolocation = {
            latitude: 48.8566,
            longitude: 2.3522
        };
        
        var location: Location = {
            id: "loc_fr_001",
            name: "Café de la Paix",
            email: "contact@cafedelapaix.fr",
            phone: "+33-1-42-86-82-82",
            address: address,
            geolocation: geolocation,
            timezone: "Europe/Paris"
        };
        
        Assert.equals("loc_fr_001", location.id);
        Assert.equals("Café de la Paix", location.name);
        Assert.equals("contact@cafedelapaix.fr", location.email);
        Assert.equals("+33-1-42-86-82-82", location.phone);
        Assert.equals("Europe/Paris", location.timezone);
        Assert.equals("Paris", location.address.city);
        Assert.equals("FR", location.address.country);
    }
}