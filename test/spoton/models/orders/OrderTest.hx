package test.spoton.models.orders;

import utest.Test;
import utest.Assert;
import spoton.models.orders.Order;
import spoton.models.orders.OrderItem;
import spoton.models.orders.OrderState;
import spoton.models.orders.OrderSource;
import spoton.models.orders.OrderCustomer;
import spoton.models.orders.OrderFulfillment;
import spoton.models.orders.OrderTotals;
import spoton.models.orders.FulfillmentType;

/**
 * Test suite for Order model
 * Tests complete order structure, nested objects, and complex scenarios
 */
class OrderTest extends Test {
    
    function testCompleteOrderCreation() {
        var lineItems: Array<OrderItem> = [
            {
                line_id: "line_001",
                item_id: "item_burger",
                name: "Cheeseburger",
                quantity: 1,
                price: 1299
            },
            {
                line_id: "line_002",
                item_id: "item_fries",
                name: "French Fries",
                quantity: 1,
                price: 499
            }
        ];
        
        var customer: OrderCustomer = {
            id: "cust_123",
            external_reference_id: "ext_456",
            first_name: "John",
            last_name: "Doe",
            email: "john.doe@example.com",
            phone: "+1-555-123-4567"
        };
        
        var fulfillment: OrderFulfillment = {
            type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            schedule_type: "ASAP",
            status: "PENDING"
        };
        
        var totals: OrderTotals = {
            subtotal: 1798,
            tip_total: 300,
            discounts_total: 0,
            tax_total: 144,
            grand_total: 2242,
            fees_total: 0
        };
        
        var source: OrderSource = {
            name: "mobile_app"
        };
        
        var order: Order = {
            id: "order_789",
            external_reference_id: "ext_order_123",
            location_id: "loc_456",
            line_items: lineItems,
            state: OrderState.ORDER_STATE_OPEN,
            source: source,
            customer: customer,
            fulfillment: fulfillment,
            totals: totals,
            menu_id: "menu_001"
        };
        
        // Test main order properties
        Assert.equals("order_789", order.id);
        Assert.equals("ext_order_123", order.external_reference_id);
        Assert.equals("loc_456", order.location_id);
        Assert.equals("menu_001", order.menu_id);
        Assert.equals(OrderState.ORDER_STATE_OPEN, order.state);
        
        // Test line items
        Assert.equals(2, order.line_items.length);
        Assert.equals("line_001", order.line_items[0].line_id);
        Assert.equals("Cheeseburger", order.line_items[0].name);
        Assert.equals("line_002", order.line_items[1].line_id);
        Assert.equals("French Fries", order.line_items[1].name);
        
        // Test customer
        Assert.equals("cust_123", order.customer.id);
        Assert.equals("John", order.customer.first_name);
        Assert.equals("Doe", order.customer.last_name);
        Assert.equals("john.doe@example.com", order.customer.email);
        
        // Test fulfillment
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_PICKUP, order.fulfillment.type);
        Assert.equals("ASAP", order.fulfillment.schedule_type);
        Assert.equals("PENDING", order.fulfillment.status);
        
        // Test totals
        Assert.equals(1798, order.totals.subtotal);
        Assert.equals(300, order.totals.tip_total);
        Assert.equals(2242, order.totals.grand_total);
        
        // Test source
        Assert.equals("mobile_app", order.source.name);
    }
    
    function testOrderWithEmptyLineItems() {
        var customer: OrderCustomer = {
            id: "cust_empty",
            external_reference_id: "",
            first_name: "Empty",
            last_name: "Order",
            email: "empty@example.com",
            phone: ""
        };
        
        var fulfillment: OrderFulfillment = {
            type: FulfillmentType.FULFILLMENT_TYPE_DINE_IN,
            schedule_type: "SCHEDULED",
            status: "DRAFT"
        };
        
        var totals: OrderTotals = {
            subtotal: 0,
            tip_total: 0,
            discounts_total: 0,
            tax_total: 0,
            grand_total: 0,
            fees_total: 0
        };
        
        var source: OrderSource = {
            name: "web"
        };
        
        var order: Order = {
            id: "order_empty",
            external_reference_id: "",
            location_id: "loc_test",
            line_items: [],
            state: OrderState.ORDER_STATE_DRAFT,
            source: source,
            customer: customer,
            fulfillment: fulfillment,
            totals: totals,
            menu_id: "menu_test"
        };
        
        Assert.equals("order_empty", order.id);
        Assert.equals(0, order.line_items.length);
        Assert.equals(OrderState.ORDER_STATE_DRAFT, order.state);
        Assert.equals(0, order.totals.grand_total);
    }
    
    function testOrderStateTransitions() {
        var order: Order = createBasicOrder();
        
        // Test state transitions
        order.state = OrderState.ORDER_STATE_DRAFT;
        Assert.equals(OrderState.ORDER_STATE_DRAFT, order.state);
        
        order.state = OrderState.ORDER_STATE_OPEN;
        Assert.equals(OrderState.ORDER_STATE_OPEN, order.state);
        
        order.state = OrderState.ORDER_STATE_CLOSED;
        Assert.equals(OrderState.ORDER_STATE_CLOSED, order.state);
        
        order.state = OrderState.ORDER_STATE_CANCELED;
        Assert.equals(OrderState.ORDER_STATE_CANCELED, order.state);
    }
    
    function testOrderWithMultipleFulfillmentTypes() {
        var order1 = createBasicOrder();
        var order2 = createBasicOrder();
        var order3 = createBasicOrder();
        
        order1.fulfillment.type = FulfillmentType.FULFILLMENT_TYPE_DINE_IN;
        order2.fulfillment.type = FulfillmentType.FULFILLMENT_TYPE_PICKUP;
        order3.fulfillment.type = FulfillmentType.FULFILLMENT_TYPE_DELIVERY;
        
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DINE_IN, order1.fulfillment.type);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_PICKUP, order2.fulfillment.type);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DELIVERY, order3.fulfillment.type);
    }
    
    function testOrderTotalsCalculation() {
        var order = createBasicOrder();
        
        // Test that totals can be modified
        order.totals.subtotal = 2000;
        order.totals.tax_total = 160;
        order.totals.tip_total = 400;
        order.totals.fees_total = 50;
        order.totals.discounts_total = 100;
        
        // Calculate expected grand total: subtotal + tax + tip + fees - discounts
        var expectedGrandTotal = 2000 + 160 + 400 + 50 - 100;
        order.totals.grand_total = expectedGrandTotal;
        
        Assert.equals(2000, order.totals.subtotal);
        Assert.equals(160, order.totals.tax_total);
        Assert.equals(400, order.totals.tip_total);
        Assert.equals(50, order.totals.fees_total);
        Assert.equals(100, order.totals.discounts_total);
        Assert.equals(2510, order.totals.grand_total);
    }
    
    function testOrderLineItemManipulation() {
        var order = createBasicOrder();
        
        // Add a new line item
        var newItem: OrderItem = {
            line_id: "line_new",
            item_id: "item_dessert",
            name: "Chocolate Cake",
            quantity: 1,
            price: 699
        };
        
        order.line_items.push(newItem);
        Assert.equals(2, order.line_items.length);
        Assert.equals("Chocolate Cake", order.line_items[1].name);
        
        // Remove the first item
        order.line_items.shift();
        Assert.equals(1, order.line_items.length);
        Assert.equals("Chocolate Cake", order.line_items[0].name);
    }
    
    function testOrderCustomerInformation() {
        var order = createBasicOrder();
        
        // Test customer information modification
        order.customer.first_name = "Jane";
        order.customer.last_name = "Smith";
        order.customer.email = "jane.smith@example.com";
        order.customer.phone = "+1-555-987-6543";
        
        Assert.equals("Jane", order.customer.first_name);
        Assert.equals("Smith", order.customer.last_name);
        Assert.equals("jane.smith@example.com", order.customer.email);
        Assert.equals("+1-555-987-6543", order.customer.phone);
    }
    
    // Helper method to create a basic order for testing
    private function createBasicOrder(): Order {
        var lineItems: Array<OrderItem> = [
            {
                line_id: "line_basic",
                item_id: "item_basic",
                name: "Basic Item",
                quantity: 1,
                price: 1000
            }
        ];
        
        var customer: OrderCustomer = {
            id: "cust_basic",
            external_reference_id: "ext_basic",
            first_name: "Test",
            last_name: "Customer",
            email: "test@example.com",
            phone: "+1-555-000-0000"
        };
        
        var fulfillment: OrderFulfillment = {
            type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            schedule_type: "ASAP",
            status: "PENDING"
        };
        
        var totals: OrderTotals = {
            subtotal: 1000,
            tip_total: 0,
            discounts_total: 0,
            tax_total: 80,
            grand_total: 1080,
            fees_total: 0
        };
        
        var source: OrderSource = {
            name: "test"
        };
        
        return {
            id: "order_basic",
            external_reference_id: "ext_order_basic",
            location_id: "loc_basic",
            line_items: lineItems,
            state: OrderState.ORDER_STATE_OPEN,
            source: source,
            customer: customer,
            fulfillment: fulfillment,
            totals: totals,
            menu_id: "menu_basic"
        };
    }
}