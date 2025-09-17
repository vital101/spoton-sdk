package test.spoton.models.loyalty;

import utest.Test;
import utest.Assert;
import spoton.models.loyalty.Customer;

/**
 * Test suite for Customer model
 * Tests model structure, property access, and loyalty points handling
 */
class CustomerTest extends Test {
    
    function testCustomerCreation() {
        var customer: Customer = {
            id: "cust_123456789",
            email: "customer@example.com",
            phone: "+1-555-123-4567",
            full_name: "John Doe",
            points_available: 1500
        };
        
        Assert.equals("cust_123456789", customer.id);
        Assert.equals("customer@example.com", customer.email);
        Assert.equals("+1-555-123-4567", customer.phone);
        Assert.equals("John Doe", customer.full_name);
        Assert.equals(1500, customer.points_available);
    }
    
    function testCustomerWithEmptyValues() {
        var customer: Customer = {
            id: "",
            email: "",
            phone: "",
            full_name: "",
            points_available: 0
        };
        
        Assert.equals("", customer.id);
        Assert.equals("", customer.email);
        Assert.equals("", customer.phone);
        Assert.equals("", customer.full_name);
        Assert.equals(0, customer.points_available);
    }
    
    function testCustomerPropertyModification() {
        var customer: Customer = {
            id: "cust_original",
            email: "original@example.com",
            phone: "+1-555-000-0000",
            full_name: "Original Name",
            points_available: 100
        };
        
        // Modify properties
        customer.id = "cust_updated";
        customer.email = "updated@example.com";
        customer.phone = "+1-555-999-9999";
        customer.full_name = "Updated Name";
        customer.points_available = 2500;
        
        Assert.equals("cust_updated", customer.id);
        Assert.equals("updated@example.com", customer.email);
        Assert.equals("+1-555-999-9999", customer.phone);
        Assert.equals("Updated Name", customer.full_name);
        Assert.equals(2500, customer.points_available);
    }
    
    function testCustomerPointsManipulation() {
        var customer: Customer = {
            id: "cust_points_test",
            email: "points@example.com",
            phone: "+1-555-123-4567",
            full_name: "Points Test",
            points_available: 1000
        };
        
        // Test points addition
        customer.points_available += 500;
        Assert.equals(1500, customer.points_available);
        
        // Test points subtraction
        customer.points_available -= 200;
        Assert.equals(1300, customer.points_available);
        
        // Test points reset to zero
        customer.points_available = 0;
        Assert.equals(0, customer.points_available);
        
        // Test negative points (edge case)
        customer.points_available = -100;
        Assert.equals(-100, customer.points_available);
    }
    
    function testCustomerWithInternationalData() {
        var customer: Customer = {
            id: "cust_international",
            email: "customer@example.fr",
            phone: "+33-1-42-86-82-82",
            full_name: "Jean-Pierre Dupont",
            points_available: 750
        };
        
        Assert.equals("cust_international", customer.id);
        Assert.equals("customer@example.fr", customer.email);
        Assert.equals("+33-1-42-86-82-82", customer.phone);
        Assert.equals("Jean-Pierre Dupont", customer.full_name);
        Assert.equals(750, customer.points_available);
    }
    
    function testCustomerEmailFormats() {
        var customer: Customer = {
            id: "cust_email_test",
            email: "test@domain.com",
            phone: "+1-555-123-4567",
            full_name: "Email Test",
            points_available: 0
        };
        
        // Test various email formats
        customer.email = "simple@domain.com";
        Assert.equals("simple@domain.com", customer.email);
        
        customer.email = "user.name+tag@example.co.uk";
        Assert.equals("user.name+tag@example.co.uk", customer.email);
        
        customer.email = "test123@sub.domain.org";
        Assert.equals("test123@sub.domain.org", customer.email);
        
        customer.email = "customer_2024@loyalty-program.com";
        Assert.equals("customer_2024@loyalty-program.com", customer.email);
    }
    
    function testCustomerPhoneFormats() {
        var customer: Customer = {
            id: "cust_phone_test",
            email: "phone@example.com",
            phone: "+1-555-123-4567",
            full_name: "Phone Test",
            points_available: 0
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
    }
    
    function testCustomerNameVariations() {
        var customer: Customer = {
            id: "cust_name_test",
            email: "name@example.com",
            phone: "+1-555-123-4567",
            full_name: "John Doe",
            points_available: 0
        };
        
        // Test single name
        customer.full_name = "Madonna";
        Assert.equals("Madonna", customer.full_name);
        
        // Test hyphenated names
        customer.full_name = "Mary-Jane Watson";
        Assert.equals("Mary-Jane Watson", customer.full_name);
        
        // Test names with titles
        customer.full_name = "Dr. John Smith Jr.";
        Assert.equals("Dr. John Smith Jr.", customer.full_name);
        
        // Test names with special characters
        customer.full_name = "José María García-López";
        Assert.equals("José María García-López", customer.full_name);
    }
    
    function testCustomerLargePointsValues() {
        var customer: Customer = {
            id: "cust_large_points",
            email: "vip@example.com",
            phone: "+1-555-123-4567",
            full_name: "VIP Customer",
            points_available: 999999
        };
        
        Assert.equals(999999, customer.points_available);
        
        // Test very large points value
        customer.points_available = 2147483647; // Max int value
        Assert.equals(2147483647, customer.points_available);
    }
}