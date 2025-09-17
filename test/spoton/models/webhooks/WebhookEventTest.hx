package test.spoton.models.webhooks;

import utest.Test;
import utest.Assert;
import spoton.models.webhooks.WebhookEvent;

/**
 * Test suite for WebhookEvent model
 * Tests model structure, property access, and webhook event scenarios
 */
class WebhookEventTest extends Test {
    
    function testWebhookEventCreation() {
        var webhookEvent: WebhookEvent = {
            id: "evt_123456789",
            timestamp: new Date(2024, 0, 15, 10, 30, 0),
            category: "order.created",
            location_id: "loc_987654321"
        };
        
        Assert.equals("evt_123456789", webhookEvent.id);
        Assert.notNull(webhookEvent.timestamp);
        Assert.equals("order.created", webhookEvent.category);
        Assert.equals("loc_987654321", webhookEvent.location_id);
    }
    
    function testWebhookEventWithDifferentCategories() {
        var orderCreatedEvent: WebhookEvent = {
            id: "evt_order_created",
            timestamp: new Date(2024, 0, 15, 10, 0, 0),
            category: "order.created",
            location_id: "loc_test"
        };
        
        var orderUpdatedEvent: WebhookEvent = {
            id: "evt_order_updated",
            timestamp: new Date(2024, 0, 15, 10, 15, 0),
            category: "order.updated",
            location_id: "loc_test"
        };
        
        var orderCanceledEvent: WebhookEvent = {
            id: "evt_order_canceled",
            timestamp: new Date(2024, 0, 15, 10, 30, 0),
            category: "order.canceled",
            location_id: "loc_test"
        };
        
        var menuUpdatedEvent: WebhookEvent = {
            id: "evt_menu_updated",
            timestamp: new Date(2024, 0, 15, 11, 0, 0),
            category: "menu.updated",
            location_id: "loc_test"
        };
        
        Assert.equals("order.created", orderCreatedEvent.category);
        Assert.equals("order.updated", orderUpdatedEvent.category);
        Assert.equals("order.canceled", orderCanceledEvent.category);
        Assert.equals("menu.updated", menuUpdatedEvent.category);
    }
    
    function testWebhookEventPropertyModification() {
        var webhookEvent: WebhookEvent = {
            id: "evt_original",
            timestamp: new Date(2024, 0, 1, 0, 0, 0),
            category: "original.category",
            location_id: "loc_original"
        };
        
        // Modify properties
        webhookEvent.id = "evt_updated";
        webhookEvent.timestamp = new Date(2024, 0, 31, 23, 59, 59);
        webhookEvent.category = "updated.category";
        webhookEvent.location_id = "loc_updated";
        
        Assert.equals("evt_updated", webhookEvent.id);
        Assert.notNull(webhookEvent.timestamp);
        Assert.equals("updated.category", webhookEvent.category);
        Assert.equals("loc_updated", webhookEvent.location_id);
    }
    
    function testWebhookEventTimestampHandling() {
        // Test different timestamp scenarios
        var morningEvent: WebhookEvent = {
            id: "evt_morning",
            timestamp: new Date(2024, 0, 15, 8, 30, 0),
            category: "test.morning",
            location_id: "loc_test"
        };
        
        var eveningEvent: WebhookEvent = {
            id: "evt_evening",
            timestamp: new Date(2024, 0, 15, 20, 45, 30),
            category: "test.evening",
            location_id: "loc_test"
        };
        
        var midnightEvent: WebhookEvent = {
            id: "evt_midnight",
            timestamp: new Date(2024, 0, 16, 0, 0, 0),
            category: "test.midnight",
            location_id: "loc_test"
        };
        
        Assert.notNull(morningEvent.timestamp);
        Assert.notNull(eveningEvent.timestamp);
        Assert.notNull(midnightEvent.timestamp);
        
        // Test that timestamps are different
        Assert.notEquals(morningEvent.timestamp.getTime(), eveningEvent.timestamp.getTime());
        Assert.notEquals(eveningEvent.timestamp.getTime(), midnightEvent.timestamp.getTime());
    }
    
    function testWebhookEventWithEmptyValues() {
        var webhookEvent: WebhookEvent = {
            id: "",
            timestamp: new Date(1970, 0, 1, 0, 0, 0),
            category: "",
            location_id: ""
        };
        
        Assert.equals("", webhookEvent.id);
        Assert.notNull(webhookEvent.timestamp);
        Assert.equals("", webhookEvent.category);
        Assert.equals("", webhookEvent.location_id);
    }
    
    function testWebhookEventUUIDFormat() {
        var webhookEvent: WebhookEvent = {
            id: "550e8400-e29b-41d4-a716-446655440000",
            timestamp: new Date(2024, 0, 15, 15, 30, 0),
            category: "uuid.test",
            location_id: "660f9500-f39c-52e5-b827-557766551111"
        };
        
        Assert.equals("550e8400-e29b-41d4-a716-446655440000", webhookEvent.id);
        Assert.notNull(webhookEvent.timestamp);
        Assert.equals("uuid.test", webhookEvent.category);
        Assert.equals("660f9500-f39c-52e5-b827-557766551111", webhookEvent.location_id);
    }
    
    function testWebhookEventCategoryFormats() {
        var webhookEvent: WebhookEvent = {
            id: "evt_category_test",
            timestamp: new Date(2024, 0, 15, 12, 0, 0),
            category: "simple",
            location_id: "loc_test"
        };
        
        // Test simple category
        Assert.equals("simple", webhookEvent.category);
        
        // Test dotted category
        webhookEvent.category = "order.created";
        Assert.equals("order.created", webhookEvent.category);
        
        // Test nested category
        webhookEvent.category = "order.item.updated";
        Assert.equals("order.item.updated", webhookEvent.category);
        
        // Test category with underscores
        webhookEvent.category = "menu_item_updated";
        Assert.equals("menu_item_updated", webhookEvent.category);
        
        // Test category with mixed separators
        webhookEvent.category = "loyalty.customer_updated";
        Assert.equals("loyalty.customer_updated", webhookEvent.category);
    }
    
    function testWebhookEventBusinessScenarios() {
        // Test common business event scenarios
        var orderEvents = [
            {
                id: "evt_order_placed",
                timestamp: new Date(2024, 0, 15, 12, 0, 0),
                category: "order.placed",
                location_id: "loc_restaurant_1"
            },
            {
                id: "evt_order_confirmed",
                timestamp: new Date(2024, 0, 15, 12, 5, 0),
                category: "order.confirmed",
                location_id: "loc_restaurant_1"
            },
            {
                id: "evt_order_ready",
                timestamp: new Date(2024, 0, 15, 12, 25, 0),
                category: "order.ready",
                location_id: "loc_restaurant_1"
            },
            {
                id: "evt_order_completed",
                timestamp: new Date(2024, 0, 15, 12, 30, 0),
                category: "order.completed",
                location_id: "loc_restaurant_1"
            }
        ];
        
        for (i in 0...orderEvents.length) {
            var event = orderEvents[i];
            var webhookEvent: WebhookEvent = {
                id: event.id,
                timestamp: event.timestamp,
                category: event.category,
                location_id: event.location_id
            };
            
            Assert.equals(event.id, webhookEvent.id);
            Assert.notNull(webhookEvent.timestamp);
            Assert.equals(event.category, webhookEvent.category);
            Assert.equals("loc_restaurant_1", webhookEvent.location_id);
        }
    }
    
    function testWebhookEventTimestampComparison() {
        var event1: WebhookEvent = {
            id: "evt_first",
            timestamp: new Date(2024, 0, 15, 10, 0, 0),
            category: "test.first",
            location_id: "loc_test"
        };
        
        var event2: WebhookEvent = {
            id: "evt_second",
            timestamp: new Date(2024, 0, 15, 10, 30, 0),
            category: "test.second",
            location_id: "loc_test"
        };
        
        // Test that second event timestamp is later than first
        Assert.isTrue(event2.timestamp.getTime() > event1.timestamp.getTime());
        
        // Test timestamp modification
        event1.timestamp = new Date(2024, 0, 15, 11, 0, 0);
        Assert.isTrue(event1.timestamp.getTime() > event2.timestamp.getTime());
    }
}