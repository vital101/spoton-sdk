package test.spoton.models.orders;

import utest.Test;
import utest.Assert;
import spoton.models.orders.OrderItem;

/**
 * Test suite for OrderItem model
 * Tests model structure, property access, and validation scenarios
 */
class OrderItemTest extends Test {
    
    function testOrderItemCreation() {
        var orderItem: OrderItem = {
            line_id: "line_123",
            item_id: "item_456",
            name: "Cheeseburger",
            quantity: 2,
            price: 1299 // $12.99 in cents
        };
        
        Assert.equals("line_123", orderItem.line_id);
        Assert.equals("item_456", orderItem.item_id);
        Assert.equals("Cheeseburger", orderItem.name);
        Assert.equals(2, orderItem.quantity);
        Assert.equals(1299, orderItem.price);
    }
    
    function testOrderItemWithSingleQuantity() {
        var orderItem: OrderItem = {
            line_id: "line_001",
            item_id: "item_001",
            name: "Coffee",
            quantity: 1,
            price: 350 // $3.50 in cents
        };
        
        Assert.equals("line_001", orderItem.line_id);
        Assert.equals("item_001", orderItem.item_id);
        Assert.equals("Coffee", orderItem.name);
        Assert.equals(1, orderItem.quantity);
        Assert.equals(350, orderItem.price);
    }
    
    function testOrderItemWithZeroPrice() {
        var orderItem: OrderItem = {
            line_id: "line_free",
            item_id: "item_promo",
            name: "Free Sample",
            quantity: 1,
            price: 0
        };
        
        Assert.equals("line_free", orderItem.line_id);
        Assert.equals("item_promo", orderItem.item_id);
        Assert.equals("Free Sample", orderItem.name);
        Assert.equals(1, orderItem.quantity);
        Assert.equals(0, orderItem.price);
    }
    
    function testOrderItemPropertyModification() {
        var orderItem: OrderItem = {
            line_id: "line_123",
            item_id: "item_456",
            name: "Cheeseburger",
            quantity: 2,
            price: 1299
        };
        
        // Modify properties
        orderItem.line_id = "line_456";
        orderItem.item_id = "item_789";
        orderItem.name = "Bacon Cheeseburger";
        orderItem.quantity = 3;
        orderItem.price = 1599;
        
        Assert.equals("line_456", orderItem.line_id);
        Assert.equals("item_789", orderItem.item_id);
        Assert.equals("Bacon Cheeseburger", orderItem.name);
        Assert.equals(3, orderItem.quantity);
        Assert.equals(1599, orderItem.price);
    }
    
    function testOrderItemWithLargeQuantity() {
        var orderItem: OrderItem = {
            line_id: "line_bulk",
            item_id: "item_bulk",
            name: "Bulk Item",
            quantity: 100,
            price: 50 // $0.50 per item
        };
        
        Assert.equals("line_bulk", orderItem.line_id);
        Assert.equals("item_bulk", orderItem.item_id);
        Assert.equals("Bulk Item", orderItem.name);
        Assert.equals(100, orderItem.quantity);
        Assert.equals(50, orderItem.price);
    }
    
    function testOrderItemWithSpecialCharacters() {
        var orderItem: OrderItem = {
            line_id: "line_special_123",
            item_id: "item_café_001",
            name: "Café Latté with Extra Foam",
            quantity: 1,
            price: 475
        };
        
        Assert.equals("line_special_123", orderItem.line_id);
        Assert.equals("item_café_001", orderItem.item_id);
        Assert.equals("Café Latté with Extra Foam", orderItem.name);
        Assert.equals(1, orderItem.quantity);
        Assert.equals(475, orderItem.price);
    }
    
    function testOrderItemCalculations() {
        var orderItem: OrderItem = {
            line_id: "line_calc",
            item_id: "item_calc",
            name: "Test Item",
            quantity: 3,
            price: 1000 // $10.00 per item
        };
        
        // Test total calculation (quantity * price)
        var totalPrice = orderItem.quantity * orderItem.price;
        Assert.equals(3000, totalPrice); // $30.00 in cents
        
        // Test price per item
        var pricePerItem = Math.round(totalPrice / orderItem.quantity);
        Assert.equals(1000, pricePerItem);
    }
}