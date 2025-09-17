package test.spoton.models.orders;

import utest.Test;
import utest.Assert;
import spoton.models.orders.OrderCustomer;

/**
 * Test suite for OrderCustomer model
 * Tests model structure, property access, and customer data scenarios
 */
class OrderCustomerTest extends Test {
    
    function testOrderCustomerCreation() {
        var customer: OrderCustomer = {
            id: "cust_123456789",
            external_reference_id: "ext_ref_987654321",
            first_name: "John",
            last_name: "Doe",
            email: "john.doe@example.com",
            phone: "+1-555-123-4567"
        };
        
        Assert.equals("cust_123456789", customer.id);
        Assert.equals("ext_ref_987654321", customer.external_reference_id);
        Assert.equals("John", customer.first_name);
        Assert.equals("Doe", customer.last_name);
        Assert.equals("john.doe@example.com", customer.email);
        Assert.equals("+1-555-123-4567", customer.phone);
    }
    
    function testOrderCustomerWithEmptyValues() {
        var customer: OrderCustomer = {
            id: "",
            external_reference_id: "",
            first_name: "",
            last_name: "",
            email: "",
            phone: ""
        };
        
        Assert.equals("", customer.id);
        Assert.equals("", customer.external_reference_id);
        Assert.equals("", customer.first_name);
        Assert.equals("", customer.last_name);
        Assert.equals("", customer.email);
        Assert.equals("", customer.phone);
    }
    
    function testOrderCustomerPropertyModification() {
        var customer: OrderCustomer = {
            id: "cust_original",
            external_reference_id: "ext_original",
            first_name: "Original",
            last_name: "Name",
            email: "original@example.com",
            phone: "+1-555-000-0000"
        };
        
        // Modify properties
        customer.id = "cust_updated";
        customer.external_reference_id = "ext_updated";
        customer.first_name = "Updated";
        customer.last_name = "Customer";
        customer.email = "updated@example.com";
        customer.phone = "+1-555-999-9999";
        
        Assert.equals("cust_updated", customer.id);
        Assert.equals("ext_updated", customer.external_reference_id);
        Assert.equals("Updated", customer.first_name);
        Assert.equals("Customer", customer.last_name);
        Assert.equals("updated@example.com", customer.email);
        Assert.equals("+1-555-999-9999", customer.phone);
    }
    
    function testOrderCustomerWithSpecialCharacters() {
        var customer: OrderCustomer = {
            id: "cust_special_chars",
            external_reference_id: "ext_special_123",
            first_name: "José",
            last_name: "García-López",
            email: "jose.garcia-lopez@example.com",
            phone: "+34-91-123-4567"
        };
        
        Assert.equals("cust_special_chars", customer.id);
        Assert.equals("ext_special_123", customer.external_reference_id);
        Assert.equals("José", customer.first_name);
        Assert.equals("García-López", customer.last_name);
        Assert.equals("jose.garcia-lopez@example.com", customer.email);
        Assert.equals("+34-91-123-4567", customer.phone);
    }
    
    function testOrderCustomerEmailFormats() {
        var customer: OrderCustomer = {
            id: "cust_email_test",
            external_reference_id: "ext_email_test",
            first_name: "Email",
            last_name: "Test",
            email: "test@domain.com",
            phone: "+1-555-123-4567"
        };
        
        // Test various email formats
        customer.email = "simple@domain.com";
        Assert.equals("simple@domain.com", customer.email);
        
        customer.email = "user.name+tag@example.co.uk";
        Assert.equals("user.name+tag@example.co.uk", customer.email);
        
        customer.email = "test123@sub.domain.org";
        Assert.equals("test123@sub.domain.org", customer.email);
        
        customer.email = "customer_2024@order-system.com";
        Assert.equals("customer_2024@order-system.com", customer.email);
    }
    
    function testOrderCustomerPhoneFormats() {
        var customer: OrderCustomer = {
            id: "cust_phone_test",
            external_reference_id: "ext_phone_test",
            first_name: "Phone",
            last_name: "Test",
            email: "phone@example.com",
            phone: "+1-555-123-4567"
        };
        
        // Test various phone formats
        customer.phone = "+1-555-123-4567";
        Assert.equals("+1-555-123-4567", customer.phone);
        
        customer.phone = "(555) 123-4567";
        Assert.equals("(555) 123-4567", customer.phone);
        
        customer.phone = "555.123.4567";
        Assert.equals("555.123.4567", customer.phone);
        
        customer.phone = "5551234567";
        Assert.equals("5551234567", customer.phone);
        
        customer.phone = "+44-20-7946-0958";
        Assert.equals("+44-20-7946-0958", customer.phone);
        
        customer.phone = "+33-1-42-86-82-82";
        Assert.equals("+33-1-42-86-82-82", customer.phone);
    }
    
    function testOrderCustomerNameVariations() {
        var customer: OrderCustomer = {
            id: "cust_name_test",
            external_reference_id: "ext_name_test",
            first_name: "John",
            last_name: "Doe",
            email: "name@example.com",
            phone: "+1-555-123-4567"
        };
        
        // Test single name scenarios
        customer.first_name = "Madonna";
        customer.last_name = "";
        Assert.equals("Madonna", customer.first_name);
        Assert.equals("", customer.last_name);
        
        // Test hyphenated names
        customer.first_name = "Mary-Jane";
        customer.last_name = "Watson-Parker";
        Assert.equals("Mary-Jane", customer.first_name);
        Assert.equals("Watson-Parker", customer.last_name);
        
        // Test names with titles
        customer.first_name = "Dr. John";
        customer.last_name = "Smith Jr.";
        Assert.equals("Dr. John", customer.first_name);
        Assert.equals("Smith Jr.", customer.last_name);
        
        // Test very short names
        customer.first_name = "A";
        customer.last_name = "B";
        Assert.equals("A", customer.first_name);
        Assert.equals("B", customer.last_name);
    }
    
    function testOrderCustomerExternalReferenceId() {
        var customer: OrderCustomer = {
            id: "cust_ext_ref_test",
            external_reference_id: "external_123",
            first_name: "External",
            last_name: "Reference",
            email: "external@example.com",
            phone: "+1-555-123-4567"
        };
        
        // Test different external reference formats
        customer.external_reference_id = "external_123";
        Assert.equals("external_123", customer.external_reference_id);
        
        customer.external_reference_id = "EXT-456-789";
        Assert.equals("EXT-456-789", customer.external_reference_id);
        
        customer.external_reference_id = "550e8400-e29b-41d4-a716-446655440000";
        Assert.equals("550e8400-e29b-41d4-a716-446655440000", customer.external_reference_id);
        
        customer.external_reference_id = "legacy_customer_001";
        Assert.equals("legacy_customer_001", customer.external_reference_id);
        
        // Test empty external reference
        customer.external_reference_id = "";
        Assert.equals("", customer.external_reference_id);
    }
    
    function testOrderCustomerUUIDFormat() {
        var customer: OrderCustomer = {
            id: "550e8400-e29b-41d4-a716-446655440000",
            external_reference_id: "660f9500-f39c-52e5-b827-557766551111",
            first_name: "UUID",
            last_name: "Customer",
            email: "uuid@example.com",
            phone: "+1-555-123-4567"
        };
        
        Assert.equals("550e8400-e29b-41d4-a716-446655440000", customer.id);
        Assert.equals("660f9500-f39c-52e5-b827-557766551111", customer.external_reference_id);
        Assert.equals("UUID", customer.first_name);
        Assert.equals("Customer", customer.last_name);
        Assert.equals("uuid@example.com", customer.email);
        Assert.equals("+1-555-123-4567", customer.phone);
    }
    
    function testOrderCustomerLongNames() {
        var longFirstName = "VeryLongFirstNameThatExceedsNormalLengthExpectations";
        var longLastName = "VeryLongLastNameThatExceedsNormalLengthExpectationsAsWell";
        
        var customer: OrderCustomer = {
            id: "cust_long_names",
            external_reference_id: "ext_long_names",
            first_name: longFirstName,
            last_name: longLastName,
            email: "longnames@example.com",
            phone: "+1-555-123-4567"
        };
        
        Assert.equals("cust_long_names", customer.id);
        Assert.equals("ext_long_names", customer.external_reference_id);
        Assert.equals(longFirstName, customer.first_name);
        Assert.equals(longLastName, customer.last_name);
        Assert.equals("longnames@example.com", customer.email);
        Assert.equals("+1-555-123-4567", customer.phone);
    }
}