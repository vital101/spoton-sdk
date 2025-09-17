package test.spoton.models.common;

import utest.Test;
import utest.Assert;
import spoton.models.common.Geolocation;

/**
 * Test suite for Geolocation model
 * Tests model structure, property access, and coordinate validation
 */
class GeolocationTest extends Test {
    
    function testGeolocationCreation() {
        var geolocation: Geolocation = {
            latitude: 37.7749,
            longitude: -122.4194
        };
        
        Assert.floatEquals(37.7749, geolocation.latitude);
        Assert.floatEquals(-122.4194, geolocation.longitude);
    }
    
    function testGeolocationWithZeroCoordinates() {
        var geolocation: Geolocation = {
            latitude: 0.0,
            longitude: 0.0
        };
        
        Assert.floatEquals(0.0, geolocation.latitude);
        Assert.floatEquals(0.0, geolocation.longitude);
    }
    
    function testGeolocationWithExtremeCoordinates() {
        // Test maximum valid latitude/longitude values
        var geolocation: Geolocation = {
            latitude: 90.0,
            longitude: 180.0
        };
        
        Assert.floatEquals(90.0, geolocation.latitude);
        Assert.floatEquals(180.0, geolocation.longitude);
        
        // Test minimum valid latitude/longitude values
        geolocation.latitude = -90.0;
        geolocation.longitude = -180.0;
        
        Assert.floatEquals(-90.0, geolocation.latitude);
        Assert.floatEquals(-180.0, geolocation.longitude);
    }
    
    function testGeolocationPropertyModification() {
        var geolocation: Geolocation = {
            latitude: 37.7749,
            longitude: -122.4194
        };
        
        // Modify coordinates
        geolocation.latitude = 40.7128;
        geolocation.longitude = -74.0060;
        
        Assert.floatEquals(40.7128, geolocation.latitude);
        Assert.floatEquals(-74.0060, geolocation.longitude);
    }
    
    function testGeolocationWithHighPrecision() {
        var geolocation: Geolocation = {
            latitude: 37.774929,
            longitude: -122.419416
        };
        
        Assert.floatEquals(37.774929, geolocation.latitude);
        Assert.floatEquals(-122.419416, geolocation.longitude);
    }
}