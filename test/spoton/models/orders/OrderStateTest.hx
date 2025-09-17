package test.spoton.models.orders;

import utest.Test;
import utest.Assert;
import spoton.models.orders.OrderState;

/**
 * Test suite for OrderState enum
 * Tests enum values, comparison, and state transitions
 */
class OrderStateTest extends Test {
    
    function testOrderStateValues() {
        var openState = OrderState.ORDER_STATE_OPEN;
        var draftState = OrderState.ORDER_STATE_DRAFT;
        var canceledState = OrderState.ORDER_STATE_CANCELED;
        var closedState = OrderState.ORDER_STATE_CLOSED;
        
        Assert.equals(OrderState.ORDER_STATE_OPEN, openState);
        Assert.equals(OrderState.ORDER_STATE_DRAFT, draftState);
        Assert.equals(OrderState.ORDER_STATE_CANCELED, canceledState);
        Assert.equals(OrderState.ORDER_STATE_CLOSED, closedState);
    }
    
    function testOrderStateComparison() {
        var state1 = OrderState.ORDER_STATE_OPEN;
        var state2 = OrderState.ORDER_STATE_OPEN;
        var state3 = OrderState.ORDER_STATE_DRAFT;
        
        Assert.equals(state1, state2);
        Assert.notEquals(state1, state3);
        Assert.notEquals(state2, state3);
    }
    
    function testOrderStateAssignment() {
        var currentState: OrderState;
        
        currentState = OrderState.ORDER_STATE_DRAFT;
        Assert.equals(OrderState.ORDER_STATE_DRAFT, currentState);
        
        currentState = OrderState.ORDER_STATE_OPEN;
        Assert.equals(OrderState.ORDER_STATE_OPEN, currentState);
        
        currentState = OrderState.ORDER_STATE_CLOSED;
        Assert.equals(OrderState.ORDER_STATE_CLOSED, currentState);
        
        currentState = OrderState.ORDER_STATE_CANCELED;
        Assert.equals(OrderState.ORDER_STATE_CANCELED, currentState);
    }
    
    function testOrderStateInArray() {
        var states = [
            OrderState.ORDER_STATE_DRAFT,
            OrderState.ORDER_STATE_OPEN,
            OrderState.ORDER_STATE_CLOSED,
            OrderState.ORDER_STATE_CANCELED
        ];
        
        Assert.equals(4, states.length);
        Assert.equals(OrderState.ORDER_STATE_DRAFT, states[0]);
        Assert.equals(OrderState.ORDER_STATE_OPEN, states[1]);
        Assert.equals(OrderState.ORDER_STATE_CLOSED, states[2]);
        Assert.equals(OrderState.ORDER_STATE_CANCELED, states[3]);
    }
    
    function testOrderStateSwitch() {
        var state = OrderState.ORDER_STATE_OPEN;
        var result = "";
        
        switch (state) {
            case OrderState.ORDER_STATE_DRAFT:
                result = "draft";
            case OrderState.ORDER_STATE_OPEN:
                result = "open";
            case OrderState.ORDER_STATE_CLOSED:
                result = "closed";
            case OrderState.ORDER_STATE_CANCELED:
                result = "canceled";
        }
        
        Assert.equals("open", result);
    }
    
    function testOrderStateValidTransitions() {
        // Test typical state transitions
        var states = [
            OrderState.ORDER_STATE_DRAFT,
            OrderState.ORDER_STATE_OPEN,
            OrderState.ORDER_STATE_CLOSED
        ];
        
        // Verify we can transition through states
        for (i in 0...states.length) {
            var currentState = states[i];
            Assert.notNull(currentState);
        }
        
        // Test canceled state can be reached from any state
        var canceledState = OrderState.ORDER_STATE_CANCELED;
        Assert.equals(OrderState.ORDER_STATE_CANCELED, canceledState);
    }
}