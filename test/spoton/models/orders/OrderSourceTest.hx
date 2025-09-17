package test.spoton.models.orders;

import utest.Test;
import utest.Assert;
import spoton.models.orders.OrderSource;

/**
 * Test suite for OrderSource model
 * Tests model structure, property access, and order source scenarios
 */
class OrderSourceTest extends Test {
    
    function testOrderSourceCreation() {
        var source: OrderSource = {
            name: "mobile_app"
        };
        
        Assert.equals("mobile_app", source.name);
    }
    
    function testOrderSourceWithEmptyValue() {
        var source: OrderSource = {
            name: ""
        };
        
        Assert.equals("", source.name);
    }
    
    function testOrderSourcePropertyModification() {
        var source: OrderSource = {
            name: "original_source"
        };
        
        // Modify property
        source.name = "updated_source";
        
        Assert.equals("updated_source", source.name);
    }
    
    function testOrderSourceCommonValues() {
        var mobileSource: OrderSource = {
            name: "mobile_app"
        };
        
        var webSource: OrderSource = {
            name: "web"
        };
        
        var posSource: OrderSource = {
            name: "pos"
        };
        
        var kioskSource: OrderSource = {
            name: "kiosk"
        };
        
        Assert.equals("mobile_app", mobileSource.name);
        Assert.equals("web", webSource.name);
        Assert.equals("pos", posSource.name);
        Assert.equals("kiosk", kioskSource.name);
    }
    
    function testOrderSourceThirdPartyIntegrations() {
        var uberEatsSource: OrderSource = {
            name: "uber_eats"
        };
        
        var doorDashSource: OrderSource = {
            name: "door_dash"
        };
        
        var grubHubSource: OrderSource = {
            name: "grub_hub"
        };
        
        var postmatesSource: OrderSource = {
            name: "postmates"
        };
        
        Assert.equals("uber_eats", uberEatsSource.name);
        Assert.equals("door_dash", doorDashSource.name);
        Assert.equals("grub_hub", grubHubSource.name);
        Assert.equals("postmates", postmatesSource.name);
    }
    
    function testOrderSourceCustomValues() {
        var customSource: OrderSource = {
            name: "custom_integration"
        };
        
        var legacySource: OrderSource = {
            name: "legacy_system"
        };
        
        var apiSource: OrderSource = {
            name: "api_direct"
        };
        
        Assert.equals("custom_integration", customSource.name);
        Assert.equals("legacy_system", legacySource.name);
        Assert.equals("api_direct", apiSource.name);
    }
    
    function testOrderSourceWithSpecialCharacters() {
        var source: OrderSource = {
            name: "third-party_delivery"
        };
        
        Assert.equals("third-party_delivery", source.name);
        
        source.name = "mobile_app_v2.0";
        Assert.equals("mobile_app_v2.0", source.name);
        
        source.name = "pos-system-2024";
        Assert.equals("pos-system-2024", source.name);
        
        source.name = "web_portal_beta";
        Assert.equals("web_portal_beta", source.name);
    }
    
    function testOrderSourceCaseVariations() {
        var source: OrderSource = {
            name: "mobile_app"
        };
        
        // Test different case variations
        source.name = "mobile_app";
        Assert.equals("mobile_app", source.name);
        
        source.name = "MOBILE_APP";
        Assert.equals("MOBILE_APP", source.name);
        
        source.name = "Mobile_App";
        Assert.equals("Mobile_App", source.name);
        
        source.name = "mobileApp";
        Assert.equals("mobileApp", source.name);
        
        source.name = "MobileApp";
        Assert.equals("MobileApp", source.name);
    }
    
    function testOrderSourceLongNames() {
        var longName = "very_long_source_name_that_exceeds_normal_expectations_for_testing_purposes";
        
        var source: OrderSource = {
            name: longName
        };
        
        Assert.equals(longName, source.name);
    }
    
    function testOrderSourceNumericValues() {
        var source: OrderSource = {
            name: "source_v1"
        };
        
        Assert.equals("source_v1", source.name);
        
        source.name = "integration_2024";
        Assert.equals("integration_2024", source.name);
        
        source.name = "api_v3.1.4";
        Assert.equals("api_v3.1.4", source.name);
        
        source.name = "system_123";
        Assert.equals("system_123", source.name);
    }
    
    function testOrderSourceBusinessScenarios() {
        // Test realistic business scenarios
        var sources = [
            { name: "mobile_app" },
            { name: "web_ordering" },
            { name: "phone_order" },
            { name: "walk_in" },
            { name: "catering_portal" },
            { name: "loyalty_app" },
            { name: "facebook_ordering" },
            { name: "google_ordering" }
        ];
        
        for (i in 0...sources.length) {
            var sourceData = sources[i];
            var source: OrderSource = {
                name: sourceData.name
            };
            
            Assert.equals(sourceData.name, source.name);
        }
    }
    
    function testOrderSourceWhitespaceHandling() {
        var source: OrderSource = {
            name: "mobile app"
        };
        
        // Test names with spaces
        Assert.equals("mobile app", source.name);
        
        source.name = " mobile_app ";
        Assert.equals(" mobile_app ", source.name);
        
        source.name = "mobile\tapp";
        Assert.equals("mobile\tapp", source.name);
        
        source.name = "mobile\napp";
        Assert.equals("mobile\napp", source.name);
    }
    
    function testOrderSourceEquality() {
        var source1: OrderSource = {
            name: "mobile_app"
        };
        
        var source2: OrderSource = {
            name: "mobile_app"
        };
        
        var source3: OrderSource = {
            name: "web"
        };
        
        // Test that sources with same name have same name value
        Assert.equals(source1.name, source2.name);
        Assert.notEquals(source1.name, source3.name);
        
        // Test name modification
        source2.name = "web";
        Assert.equals(source2.name, source3.name);
        Assert.notEquals(source1.name, source2.name);
    }
}