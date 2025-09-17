package test.spoton.models.common;

import utest.Test;
import utest.Assert;
import spoton.models.common.Address;

/**
 * Test suite for Address model
 * Tests model structure, property access, and validation scenarios
 */
class AddressTest extends Test {
    
    function testAddressCreation() {
        var address: Address = {
            address_line_1: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zip: "94105",
            country: "US"
        };
        
        Assert.equals("123 Main St", address.address_line_1);
        Assert.equals("San Francisco", address.city);
        Assert.equals("CA", address.state);
        Assert.equals("94105", address.zip);
        Assert.equals("US", address.country);
    }
    
    function testAddressWithEmptyValues() {
        var address: Address = {
            address_line_1: "",
            city: "",
            state: "",
            zip: "",
            country: ""
        };
        
        Assert.equals("", address.address_line_1);
        Assert.equals("", address.city);
        Assert.equals("", address.state);
        Assert.equals("", address.zip);
        Assert.equals("", address.country);
    }
    
    function testAddressPropertyModification() {
        var address: Address = {
            address_line_1: "123 Main St",
            city: "San Francisco",
            state: "CA",
            zip: "94105",
            country: "US"
        };
        
        // Modify properties
        address.address_line_1 = "456 Oak Ave";
        address.city = "Los Angeles";
        address.state = "CA";
        address.zip = "90210";
        address.country = "US";
        
        Assert.equals("456 Oak Ave", address.address_line_1);
        Assert.equals("Los Angeles", address.city);
        Assert.equals("CA", address.state);
        Assert.equals("90210", address.zip);
        Assert.equals("US", address.country);
    }
    
    function testAddressWithSpecialCharacters() {
        var address: Address = {
            address_line_1: "123 Main St, Apt #4B",
            city: "São Paulo",
            state: "SP",
            zip: "01234-567",
            country: "BR"
        };
        
        Assert.equals("123 Main St, Apt #4B", address.address_line_1);
        Assert.equals("São Paulo", address.city);
        Assert.equals("SP", address.state);
        Assert.equals("01234-567", address.zip);
        Assert.equals("BR", address.country);
    }
}