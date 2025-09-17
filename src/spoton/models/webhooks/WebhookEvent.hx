package spoton.models.webhooks;

/**
 * Represents a webhook event from SpotOn's API
 */
typedef WebhookEvent = {
    /**
     * Unique identifier for the webhook event (UUID format)
     */
    var id: String;
    
    /**
     * Timestamp when the event occurred
     */
    var timestamp: Date;
    
    /**
     * Category of the webhook event
     */
    var category: String;
    
    /**
     * Location ID associated with the event
     */
    var location_id: String;
}