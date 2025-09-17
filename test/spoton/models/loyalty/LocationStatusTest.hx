package test.spoton.models.loyalty;

import utest.Test;
import utest.Assert;
import spoton.models.loyalty.LocationStatus;

/**
 * Test suite for LocationStatus model
 * Tests model structure, property access, and loyalty configuration scenarios
 */
class LocationStatusTest extends Test {
    
    function testLocationStatusCreation() {
        var locationStatus: LocationStatus = {
            location_id: "loc_123456789",
            loyalty_enabled: true,
            active: true,
            configuration: null,
            updated_at: null
        };
        
        Assert.equals("loc_123456789", locationStatus.location_id);
        Assert.isTrue(locationStatus.loyalty_enabled);
        Assert.isTrue(locationStatus.active);
        Assert.isNull(locationStatus.configuration);
        Assert.isNull(locationStatus.updated_at);
    }
    
    function testLocationStatusWithConfiguration() {
        var config = {
            points_per_dollar: 10,
            minimum_redemption: 100,
            expiration_days: 365
        };
        
        var locationStatus: LocationStatus = {
            location_id: "loc_with_config",
            loyalty_enabled: true,
            active: true,
            configuration: config,
            updated_at: "2024-01-15T10:30:00Z"
        };
        
        Assert.equals("loc_with_config", locationStatus.location_id);
        Assert.isTrue(locationStatus.loyalty_enabled);
        Assert.isTrue(locationStatus.active);
        Assert.notNull(locationStatus.configuration);
        Assert.equals("2024-01-15T10:30:00Z", locationStatus.updated_at);
    }
    
    function testLocationStatusDisabled() {
        var locationStatus: LocationStatus = {
            location_id: "loc_disabled",
            loyalty_enabled: false,
            active: false,
            configuration: null,
            updated_at: "2024-01-10T08:00:00Z"
        };
        
        Assert.equals("loc_disabled", locationStatus.location_id);
        Assert.isFalse(locationStatus.loyalty_enabled);
        Assert.isFalse(locationStatus.active);
        Assert.isNull(locationStatus.configuration);
        Assert.equals("2024-01-10T08:00:00Z", locationStatus.updated_at);
    }
    
    function testLocationStatusPropertyModification() {
        var locationStatus: LocationStatus = {
            location_id: "loc_modify_test",
            loyalty_enabled: false,
            active: false,
            configuration: null,
            updated_at: null
        };
        
        // Modify properties
        locationStatus.location_id = "loc_modified";
        locationStatus.loyalty_enabled = true;
        locationStatus.active = true;
        locationStatus.updated_at = "2024-01-20T12:00:00Z";
        
        Assert.equals("loc_modified", locationStatus.location_id);
        Assert.isTrue(locationStatus.loyalty_enabled);
        Assert.isTrue(locationStatus.active);
        Assert.equals("2024-01-20T12:00:00Z", locationStatus.updated_at);
    }
    
    function testLocationStatusEnabledButInactive() {
        var locationStatus: LocationStatus = {
            location_id: "loc_enabled_inactive",
            loyalty_enabled: true,
            active: false,
            configuration: null,
            updated_at: "2024-01-12T14:30:00Z"
        };
        
        Assert.equals("loc_enabled_inactive", locationStatus.location_id);
        Assert.isTrue(locationStatus.loyalty_enabled);
        Assert.isFalse(locationStatus.active);
        Assert.equals("2024-01-12T14:30:00Z", locationStatus.updated_at);
    }
    
    function testLocationStatusDisabledButActive() {
        var locationStatus: LocationStatus = {
            location_id: "loc_disabled_active",
            loyalty_enabled: false,
            active: true,
            configuration: null,
            updated_at: "2024-01-08T16:45:00Z"
        };
        
        Assert.equals("loc_disabled_active", locationStatus.location_id);
        Assert.isFalse(locationStatus.loyalty_enabled);
        Assert.isTrue(locationStatus.active);
        Assert.equals("2024-01-08T16:45:00Z", locationStatus.updated_at);
    }
    
    function testLocationStatusWithComplexConfiguration() {
        var complexConfig = {
            points_per_dollar: 5,
            minimum_redemption: 250,
            expiration_days: 730,
            tiers: [
                { name: "Bronze", threshold: 0, multiplier: 1.0 },
                { name: "Silver", threshold: 1000, multiplier: 1.5 },
                { name: "Gold", threshold: 5000, multiplier: 2.0 }
            ],
            special_offers: {
                birthday_bonus: 500,
                signup_bonus: 100
            }
        };
        
        var locationStatus: LocationStatus = {
            location_id: "loc_complex_config",
            loyalty_enabled: true,
            active: true,
            configuration: complexConfig,
            updated_at: "2024-01-25T09:15:00Z"
        };
        
        Assert.equals("loc_complex_config", locationStatus.location_id);
        Assert.isTrue(locationStatus.loyalty_enabled);
        Assert.isTrue(locationStatus.active);
        Assert.notNull(locationStatus.configuration);
        Assert.equals("2024-01-25T09:15:00Z", locationStatus.updated_at);
    }
    
    function testLocationStatusTimestampFormats() {
        var locationStatus: LocationStatus = {
            location_id: "loc_timestamp_test",
            loyalty_enabled: true,
            active: true,
            configuration: null,
            updated_at: "2024-01-15T10:30:00Z"
        };
        
        // Test ISO 8601 format
        Assert.equals("2024-01-15T10:30:00Z", locationStatus.updated_at);
        
        // Test different timestamp formats
        locationStatus.updated_at = "2024-01-15T10:30:00.123Z";
        Assert.equals("2024-01-15T10:30:00.123Z", locationStatus.updated_at);
        
        locationStatus.updated_at = "2024-01-15T10:30:00+00:00";
        Assert.equals("2024-01-15T10:30:00+00:00", locationStatus.updated_at);
        
        locationStatus.updated_at = "2024-01-15T05:30:00-05:00";
        Assert.equals("2024-01-15T05:30:00-05:00", locationStatus.updated_at);
    }
    
    function testLocationStatusConfigurationModification() {
        var initialConfig = {
            points_per_dollar: 10,
            minimum_redemption: 100
        };
        
        var locationStatus: LocationStatus = {
            location_id: "loc_config_modify",
            loyalty_enabled: true,
            active: true,
            configuration: initialConfig,
            updated_at: "2024-01-01T00:00:00Z"
        };
        
        Assert.notNull(locationStatus.configuration);
        
        // Modify configuration
        var newConfig = {
            points_per_dollar: 15,
            minimum_redemption: 200,
            bonus_multiplier: 2.0
        };
        
        locationStatus.configuration = newConfig;
        locationStatus.updated_at = "2024-01-02T00:00:00Z";
        
        Assert.notNull(locationStatus.configuration);
        Assert.equals("2024-01-02T00:00:00Z", locationStatus.updated_at);
        
        // Clear configuration
        locationStatus.configuration = null;
        Assert.isNull(locationStatus.configuration);
    }
    
    function testLocationStatusEmptyValues() {
        var locationStatus: LocationStatus = {
            location_id: "",
            loyalty_enabled: false,
            active: false,
            configuration: null,
            updated_at: null
        };
        
        Assert.equals("", locationStatus.location_id);
        Assert.isFalse(locationStatus.loyalty_enabled);
        Assert.isFalse(locationStatus.active);
        Assert.isNull(locationStatus.configuration);
        Assert.isNull(locationStatus.updated_at);
    }
}