package test.spoton.models.reporting;

import utest.Test;
import utest.Assert;
import spoton.models.reporting.ReportOrder;
import spoton.models.orders.OrderSource;
import spoton.models.orders.FulfillmentType;

/**
 * Test suite for ReportOrder model
 * Tests model structure, property access, and reporting data scenarios
 */
class ReportOrderTest extends Test {
    
    function testReportOrderCreation() {
        var source: OrderSource = {
            name: "mobile_app"
        };
        
        var reportOrder: ReportOrder = {
            id: "order_123456789",
            location_id: "loc_987654321",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(2024, 0, 15, 10, 30, 0)
        };
        
        Assert.equals("order_123456789", reportOrder.id);
        Assert.equals("loc_987654321", reportOrder.location_id);
        Assert.equals("mobile_app", reportOrder.source.name);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_PICKUP, reportOrder.fulfillment_type);
        Assert.notNull(reportOrder.created_at);
    }
    
    function testReportOrderWithDifferentSources() {
        var webSource: OrderSource = {
            name: "web"
        };
        
        var posSource: OrderSource = {
            name: "pos"
        };
        
        var thirdPartySource: OrderSource = {
            name: "third_party_delivery"
        };
        
        var webOrder: ReportOrder = {
            id: "order_web",
            location_id: "loc_test",
            source: webSource,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DELIVERY,
            created_at: new Date(2024, 0, 15, 12, 0, 0)
        };
        
        var posOrder: ReportOrder = {
            id: "order_pos",
            location_id: "loc_test",
            source: posSource,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DINE_IN,
            created_at: new Date(2024, 0, 15, 13, 0, 0)
        };
        
        var thirdPartyOrder: ReportOrder = {
            id: "order_third_party",
            location_id: "loc_test",
            source: thirdPartySource,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DELIVERY,
            created_at: new Date(2024, 0, 15, 14, 0, 0)
        };
        
        Assert.equals("web", webOrder.source.name);
        Assert.equals("pos", posOrder.source.name);
        Assert.equals("third_party_delivery", thirdPartyOrder.source.name);
        
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DELIVERY, webOrder.fulfillment_type);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DINE_IN, posOrder.fulfillment_type);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DELIVERY, thirdPartyOrder.fulfillment_type);
    }
    
    function testReportOrderWithAllFulfillmentTypes() {
        var source: OrderSource = {
            name: "mobile_app"
        };
        
        var dineInOrder: ReportOrder = {
            id: "order_dine_in",
            location_id: "loc_test",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DINE_IN,
            created_at: new Date(2024, 0, 15, 10, 0, 0)
        };
        
        var pickupOrder: ReportOrder = {
            id: "order_pickup",
            location_id: "loc_test",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(2024, 0, 15, 11, 0, 0)
        };
        
        var deliveryOrder: ReportOrder = {
            id: "order_delivery",
            location_id: "loc_test",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DELIVERY,
            created_at: new Date(2024, 0, 15, 12, 0, 0)
        };
        
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DINE_IN, dineInOrder.fulfillment_type);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_PICKUP, pickupOrder.fulfillment_type);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DELIVERY, deliveryOrder.fulfillment_type);
    }
    
    function testReportOrderPropertyModification() {
        var source: OrderSource = {
            name: "original_source"
        };
        
        var reportOrder: ReportOrder = {
            id: "order_original",
            location_id: "loc_original",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(2024, 0, 1, 0, 0, 0)
        };
        
        // Modify properties
        reportOrder.id = "order_updated";
        reportOrder.location_id = "loc_updated";
        reportOrder.source.name = "updated_source";
        reportOrder.fulfillment_type = FulfillmentType.FULFILLMENT_TYPE_DELIVERY;
        reportOrder.created_at = new Date(2024, 0, 31, 23, 59, 59);
        
        Assert.equals("order_updated", reportOrder.id);
        Assert.equals("loc_updated", reportOrder.location_id);
        Assert.equals("updated_source", reportOrder.source.name);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DELIVERY, reportOrder.fulfillment_type);
        Assert.notNull(reportOrder.created_at);
    }
    
    function testReportOrderDateHandling() {
        var source: OrderSource = {
            name: "test_source"
        };
        
        // Test different date scenarios
        var morningOrder: ReportOrder = {
            id: "order_morning",
            location_id: "loc_test",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(2024, 0, 15, 8, 30, 0)
        };
        
        var eveningOrder: ReportOrder = {
            id: "order_evening",
            location_id: "loc_test",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DELIVERY,
            created_at: new Date(2024, 0, 15, 20, 45, 30)
        };
        
        var midnightOrder: ReportOrder = {
            id: "order_midnight",
            location_id: "loc_test",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(2024, 0, 16, 0, 0, 0)
        };
        
        Assert.notNull(morningOrder.created_at);
        Assert.notNull(eveningOrder.created_at);
        Assert.notNull(midnightOrder.created_at);
        
        // Test that dates are different
        Assert.notEquals(morningOrder.created_at.getTime(), eveningOrder.created_at.getTime());
        Assert.notEquals(eveningOrder.created_at.getTime(), midnightOrder.created_at.getTime());
    }
    
    function testReportOrderWithEmptyValues() {
        var source: OrderSource = {
            name: ""
        };
        
        var reportOrder: ReportOrder = {
            id: "",
            location_id: "",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(1970, 0, 1, 0, 0, 0)
        };
        
        Assert.equals("", reportOrder.id);
        Assert.equals("", reportOrder.location_id);
        Assert.equals("", reportOrder.source.name);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_PICKUP, reportOrder.fulfillment_type);
        Assert.notNull(reportOrder.created_at);
    }
    
    function testReportOrderSourceModification() {
        var initialSource: OrderSource = {
            name: "initial_source"
        };
        
        var reportOrder: ReportOrder = {
            id: "order_source_test",
            location_id: "loc_test",
            source: initialSource,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_PICKUP,
            created_at: new Date(2024, 0, 15, 12, 0, 0)
        };
        
        Assert.equals("initial_source", reportOrder.source.name);
        
        // Create new source and assign
        var newSource: OrderSource = {
            name: "new_source"
        };
        
        reportOrder.source = newSource;
        Assert.equals("new_source", reportOrder.source.name);
        
        // Modify source name directly
        reportOrder.source.name = "modified_source";
        Assert.equals("modified_source", reportOrder.source.name);
    }
    
    function testReportOrderUUIDFormat() {
        var source: OrderSource = {
            name: "uuid_test"
        };
        
        var reportOrder: ReportOrder = {
            id: "550e8400-e29b-41d4-a716-446655440000",
            location_id: "660f9500-f39c-52e5-b827-557766551111",
            source: source,
            fulfillment_type: FulfillmentType.FULFILLMENT_TYPE_DELIVERY,
            created_at: new Date(2024, 0, 15, 15, 30, 0)
        };
        
        Assert.equals("550e8400-e29b-41d4-a716-446655440000", reportOrder.id);
        Assert.equals("660f9500-f39c-52e5-b827-557766551111", reportOrder.location_id);
        Assert.equals("uuid_test", reportOrder.source.name);
        Assert.equals(FulfillmentType.FULFILLMENT_TYPE_DELIVERY, reportOrder.fulfillment_type);
        Assert.notNull(reportOrder.created_at);
    }
}