package test.spoton.models.labor;

import utest.Test;
import utest.Assert;
import spoton.models.labor.Employee;

/**
 * Test suite for Employee model
 * Tests model structure, property access, and validation scenarios
 */
class EmployeeTest extends Test {
    
    function testEmployeeCreation() {
        var employee: Employee = {
            id: "emp_123456789",
            first_name: "John",
            last_name: "Doe",
            email: "john.doe@company.com",
            status: "ACTIVE"
        };
        
        Assert.equals("emp_123456789", employee.id);
        Assert.equals("John", employee.first_name);
        Assert.equals("Doe", employee.last_name);
        Assert.equals("john.doe@company.com", employee.email);
        Assert.equals("ACTIVE", employee.status);
    }
    
    function testEmployeeWithEmptyValues() {
        var employee: Employee = {
            id: "",
            first_name: "",
            last_name: "",
            email: "",
            status: ""
        };
        
        Assert.equals("", employee.id);
        Assert.equals("", employee.first_name);
        Assert.equals("", employee.last_name);
        Assert.equals("", employee.email);
        Assert.equals("", employee.status);
    }
    
    function testEmployeePropertyModification() {
        var employee: Employee = {
            id: "emp_original",
            first_name: "Original",
            last_name: "Name",
            email: "original@company.com",
            status: "INACTIVE"
        };
        
        // Modify properties
        employee.id = "emp_updated";
        employee.first_name = "Updated";
        employee.last_name = "Employee";
        employee.email = "updated@company.com";
        employee.status = "ACTIVE";
        
        Assert.equals("emp_updated", employee.id);
        Assert.equals("Updated", employee.first_name);
        Assert.equals("Employee", employee.last_name);
        Assert.equals("updated@company.com", employee.email);
        Assert.equals("ACTIVE", employee.status);
    }
    
    function testEmployeeStatusValues() {
        var employee: Employee = {
            id: "emp_status_test",
            first_name: "Status",
            last_name: "Test",
            email: "status@company.com",
            status: "ACTIVE"
        };
        
        // Test different status values
        employee.status = "ACTIVE";
        Assert.equals("ACTIVE", employee.status);
        
        employee.status = "INACTIVE";
        Assert.equals("INACTIVE", employee.status);
        
        employee.status = "TERMINATED";
        Assert.equals("TERMINATED", employee.status);
        
        employee.status = "SUSPENDED";
        Assert.equals("SUSPENDED", employee.status);
    }
    
    function testEmployeeWithSpecialCharacters() {
        var employee: Employee = {
            id: "emp_special_chars",
            first_name: "José",
            last_name: "García-López",
            email: "jose.garcia-lopez@company.com",
            status: "ACTIVE"
        };
        
        Assert.equals("emp_special_chars", employee.id);
        Assert.equals("José", employee.first_name);
        Assert.equals("García-López", employee.last_name);
        Assert.equals("jose.garcia-lopez@company.com", employee.email);
        Assert.equals("ACTIVE", employee.status);
    }
    
    function testEmployeeEmailFormats() {
        var employee: Employee = {
            id: "emp_email_test",
            first_name: "Email",
            last_name: "Test",
            email: "simple@domain.com",
            status: "ACTIVE"
        };
        
        // Test various email formats
        employee.email = "simple@domain.com";
        Assert.equals("simple@domain.com", employee.email);
        
        employee.email = "user.name+tag@example.co.uk";
        Assert.equals("user.name+tag@example.co.uk", employee.email);
        
        employee.email = "test123@sub.domain.org";
        Assert.equals("test123@sub.domain.org", employee.email);
    }
    
    function testEmployeeUUIDFormat() {
        var employee: Employee = {
            id: "550e8400-e29b-41d4-a716-446655440000",
            first_name: "UUID",
            last_name: "Test",
            email: "uuid@company.com",
            status: "ACTIVE"
        };
        
        Assert.equals("550e8400-e29b-41d4-a716-446655440000", employee.id);
        Assert.equals("UUID", employee.first_name);
        Assert.equals("Test", employee.last_name);
        Assert.equals("uuid@company.com", employee.email);
        Assert.equals("ACTIVE", employee.status);
    }
    
    function testEmployeeNameEdgeCases() {
        var employee: Employee = {
            id: "emp_name_edge",
            first_name: "A",
            last_name: "B",
            email: "ab@company.com",
            status: "ACTIVE"
        };
        
        // Test single character names
        Assert.equals("A", employee.first_name);
        Assert.equals("B", employee.last_name);
        
        // Test very long names
        employee.first_name = "VeryLongFirstNameThatExceedsNormalLength";
        employee.last_name = "VeryLongLastNameThatExceedsNormalLength";
        
        Assert.equals("VeryLongFirstNameThatExceedsNormalLength", employee.first_name);
        Assert.equals("VeryLongLastNameThatExceedsNormalLength", employee.last_name);
    }
}