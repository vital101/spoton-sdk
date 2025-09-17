package test;

import utest.Runner;
import utest.ui.Report;

/**
 * Main entry point for the SpotOn SDK test suite.
 * Uses utest directly for test execution.
 */
class TestMain {
    
    public static function main() {
        var runner = new Runner();
        
        // Core client test
        runner.addCase(new test.spoton.SpotOnClientTest());
        
        // Authentication tests
        runner.addCase(new test.spoton.auth.AuthenticationManagerTest());
        runner.addCase(new test.spoton.auth.CredentialsTest());
        
        // HTTP tests
        runner.addCase(new test.spoton.http.HTTPClientTest());
        runner.addCase(new test.spoton.http.ResponseTest());
        
        // Endpoint tests
        runner.addCase(new test.spoton.endpoints.BaseEndpointTest());
        runner.addCase(new test.spoton.endpoints.BusinessEndpointTest());
        runner.addCase(new test.spoton.endpoints.OrderEndpointTest());
        runner.addCase(new test.spoton.endpoints.MenuEndpointTest());
        
        // Model tests - Business
        runner.addCase(new test.spoton.models.business.LocationTest());
        
        // Model tests - Common
        runner.addCase(new test.spoton.models.common.AddressTest());
        runner.addCase(new test.spoton.models.common.GeolocationTest());
        
        // Model tests - Labor
        runner.addCase(new test.spoton.models.labor.EmployeeTest());
        
        // Model tests - Loyalty
        runner.addCase(new test.spoton.models.loyalty.CustomerTest());
        runner.addCase(new test.spoton.models.loyalty.LocationStatusTest());
        
        // Model tests - Menus
        runner.addCase(new test.spoton.models.menus.MenuTest());
        runner.addCase(new test.spoton.models.menus.MenuItemTest());
        
        // Model tests - Onboarding
        runner.addCase(new test.spoton.models.onboarding.LocationCandidateTest());
        
        // Model tests - Orders
        runner.addCase(new test.spoton.models.orders.OrderTest());
        runner.addCase(new test.spoton.models.orders.OrderCustomerTest());
        runner.addCase(new test.spoton.models.orders.OrderFulfillmentTest());
        runner.addCase(new test.spoton.models.orders.OrderItemTest());
        runner.addCase(new test.spoton.models.orders.OrderSourceTest());
        runner.addCase(new test.spoton.models.orders.OrderStateTest());
        runner.addCase(new test.spoton.models.orders.OrderTotalsTest());
        
        // Model tests - Reporting
        runner.addCase(new test.spoton.models.reporting.ReportOrderTest());
        
        // Model tests - Webhooks
        runner.addCase(new test.spoton.models.webhooks.WebhookEventTest());
        
        // Utility tests
        runner.addCase(new test.spoton.utils.BaseEndpointUtilsTest());
        runner.addCase(new test.spoton.utils.DataTransformationUtilsTest());
        runner.addCase(new test.spoton.utils.HTTPClientUtilsTest());
        runner.addCase(new test.spoton.utils.WebhookSignatureValidatorTest());
        
        // Error handling tests
        runner.addCase(new test.spoton.errors.SpotOnExceptionTest());
        
        // Set up reporting
        Report.create(runner);
        
        // Run tests
        runner.run();
    }
}