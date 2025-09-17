package spoton;

import spoton.SpotOnClient;
import spoton.endpoints.*;
import spoton.errors.*;
import spoton.auth.AuthenticationManagerImpl;
import spoton.http.HTTPClientImpl;
import spoton.models.orders.OrderState;
import spoton.models.orders.FulfillmentType;

/**
 * Main entry point for Node.js exports
 */
class Main {
    
    public static function main() {
        // This will be called when the module is loaded
        
        #if js
        // Export classes to the global object for Node.js
        var exports = js.Syntax.code("typeof exports !== 'undefined' ? exports : this");
        
        // Main client class
        js.Syntax.code("{0}.SpotOnClient = {1}", exports, SpotOnClient);
        
        // Endpoint classes
        js.Syntax.code("{0}.BaseEndpoint = {1}", exports, BaseEndpoint);
        js.Syntax.code("{0}.BusinessEndpoint = {1}", exports, BusinessEndpoint);
        js.Syntax.code("{0}.OrderEndpoint = {1}", exports, OrderEndpoint);
        js.Syntax.code("{0}.MenuEndpoint = {1}", exports, MenuEndpoint);
        js.Syntax.code("{0}.LoyaltyEndpoint = {1}", exports, LoyaltyEndpoint);
        js.Syntax.code("{0}.ReportingEndpoint = {1}", exports, ReportingEndpoint);
        js.Syntax.code("{0}.LaborEndpoint = {1}", exports, LaborEndpoint);
        js.Syntax.code("{0}.OnboardingEndpoint = {1}", exports, OnboardingEndpoint);
        js.Syntax.code("{0}.WebhookEndpoint = {1}", exports, WebhookEndpoint);
        
        // Authentication and HTTP
        js.Syntax.code("{0}.AuthenticationManager = {1}", exports, AuthenticationManagerImpl);
        js.Syntax.code("{0}.HTTPClient = {1}", exports, HTTPClientImpl);
        
        // Exception classes
        js.Syntax.code("{0}.SpotOnException = {1}", exports, SpotOnException);
        js.Syntax.code("{0}.AuthenticationException = {1}", exports, AuthenticationException);
        js.Syntax.code("{0}.NetworkException = {1}", exports, NetworkException);
        js.Syntax.code("{0}.APIException = {1}", exports, APIException);
        
        // Enums
        js.Syntax.code("{0}.OrderState = {1}", exports, OrderState);
        js.Syntax.code("{0}.FulfillmentType = {1}", exports, FulfillmentType);
        
        // Default export
        js.Syntax.code("{0}.default = {1}", exports, SpotOnClient);
        #end
    }
}