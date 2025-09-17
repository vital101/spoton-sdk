package spoton.models.reporting;

import spoton.models.orders.OrderSource;
import spoton.models.orders.FulfillmentType;

/**
 * ReportOrder typedef representing order data for reporting purposes
 * Contains essential order information used in reporting and analytics
 */
typedef ReportOrder = {
    /**
     * Unique SpotOn order identifier
     */
    var id: String;
    
    /**
     * Location ID where the order was placed
     */
    var location_id: String;
    
    /**
     * Source system or channel where the order originated
     */
    var source: OrderSource;
    
    /**
     * Type of fulfillment for the order (dine-in, pickup, delivery)
     */
    var fulfillment_type: FulfillmentType;
    
    /**
     * Timestamp when the order was created
     */
    var created_at: Date;
}