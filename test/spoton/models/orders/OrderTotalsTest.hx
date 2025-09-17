package test.spoton.models.orders;

import utest.Test;
import utest.Assert;
import spoton.models.orders.OrderTotals;

/**
 * Test suite for OrderTotals model
 * Tests model structure, property access, and monetary calculation scenarios
 */
class OrderTotalsTest extends Test {
    
    function testOrderTotalsCreation() {
        var totals: OrderTotals = {
            subtotal: 1500,
            tip_total: 300,
            discounts_total: 100,
            tax_total: 120,
            grand_total: 1820,
            fees_total: 0
        };
        
        Assert.equals(1500, totals.subtotal);
        Assert.equals(300, totals.tip_total);
        Assert.equals(100, totals.discounts_total);
        Assert.equals(120, totals.tax_total);
        Assert.equals(1820, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsWithZeroValues() {
        var totals: OrderTotals = {
            subtotal: 0,
            tip_total: 0,
            discounts_total: 0,
            tax_total: 0,
            grand_total: 0,
            fees_total: 0
        };
        
        Assert.equals(0, totals.subtotal);
        Assert.equals(0, totals.tip_total);
        Assert.equals(0, totals.discounts_total);
        Assert.equals(0, totals.tax_total);
        Assert.equals(0, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsPropertyModification() {
        var totals: OrderTotals = {
            subtotal: 1000,
            tip_total: 0,
            discounts_total: 0,
            tax_total: 80,
            grand_total: 1080,
            fees_total: 0
        };
        
        // Modify properties
        totals.subtotal = 2000;
        totals.tip_total = 400;
        totals.discounts_total = 200;
        totals.tax_total = 160;
        totals.fees_total = 50;
        totals.grand_total = 2410; // 2000 + 400 - 200 + 160 + 50
        
        Assert.equals(2000, totals.subtotal);
        Assert.equals(400, totals.tip_total);
        Assert.equals(200, totals.discounts_total);
        Assert.equals(160, totals.tax_total);
        Assert.equals(2410, totals.grand_total);
        Assert.equals(50, totals.fees_total);
    }
    
    function testOrderTotalsCalculationScenarios() {
        // Test typical calculation: subtotal + tax + tip + fees - discounts = grand_total
        var totals: OrderTotals = {
            subtotal: 2500,
            tip_total: 500,
            discounts_total: 250,
            tax_total: 200,
            grand_total: 2950, // 2500 + 500 - 250 + 200 + 0
            fees_total: 0
        };
        
        var expectedGrandTotal = totals.subtotal + totals.tip_total - totals.discounts_total + totals.tax_total + totals.fees_total;
        Assert.equals(expectedGrandTotal, totals.grand_total);
        Assert.equals(2950, totals.grand_total);
    }
    
    function testOrderTotalsWithFees() {
        var totals: OrderTotals = {
            subtotal: 1800,
            tip_total: 360,
            discounts_total: 0,
            tax_total: 144,
            grand_total: 2404, // 1800 + 360 + 144 + 100
            fees_total: 100
        };
        
        Assert.equals(1800, totals.subtotal);
        Assert.equals(360, totals.tip_total);
        Assert.equals(0, totals.discounts_total);
        Assert.equals(144, totals.tax_total);
        Assert.equals(2404, totals.grand_total);
        Assert.equals(100, totals.fees_total);
    }
    
    function testOrderTotalsWithLargeDiscounts() {
        var totals: OrderTotals = {
            subtotal: 3000,
            tip_total: 600,
            discounts_total: 1500, // Large discount
            tax_total: 240,
            grand_total: 2340, // 3000 + 600 - 1500 + 240
            fees_total: 0
        };
        
        Assert.equals(3000, totals.subtotal);
        Assert.equals(600, totals.tip_total);
        Assert.equals(1500, totals.discounts_total);
        Assert.equals(240, totals.tax_total);
        Assert.equals(2340, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsNoTipScenario() {
        var totals: OrderTotals = {
            subtotal: 1200,
            tip_total: 0,
            discounts_total: 120,
            tax_total: 96,
            grand_total: 1176, // 1200 + 0 - 120 + 96
            fees_total: 0
        };
        
        Assert.equals(1200, totals.subtotal);
        Assert.equals(0, totals.tip_total);
        Assert.equals(120, totals.discounts_total);
        Assert.equals(96, totals.tax_total);
        Assert.equals(1176, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsHighTipScenario() {
        var totals: OrderTotals = {
            subtotal: 5000,
            tip_total: 1500, // 30% tip
            discounts_total: 0,
            tax_total: 400,
            grand_total: 6900, // 5000 + 1500 + 400
            fees_total: 0
        };
        
        Assert.equals(5000, totals.subtotal);
        Assert.equals(1500, totals.tip_total);
        Assert.equals(0, totals.discounts_total);
        Assert.equals(400, totals.tax_total);
        Assert.equals(6900, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsComplexScenario() {
        var totals: OrderTotals = {
            subtotal: 4500,
            tip_total: 900,
            discounts_total: 450,
            tax_total: 360,
            grand_total: 5460, // 4500 + 900 - 450 + 360 + 150
            fees_total: 150
        };
        
        Assert.equals(4500, totals.subtotal);
        Assert.equals(900, totals.tip_total);
        Assert.equals(450, totals.discounts_total);
        Assert.equals(360, totals.tax_total);
        Assert.equals(5460, totals.grand_total);
        Assert.equals(150, totals.fees_total);
        
        // Verify calculation
        var calculatedTotal = totals.subtotal + totals.tip_total - totals.discounts_total + totals.tax_total + totals.fees_total;
        Assert.equals(calculatedTotal, totals.grand_total);
    }
    
    function testOrderTotalsNegativeValues() {
        // Test edge case with negative values (refunds, adjustments)
        var totals: OrderTotals = {
            subtotal: 1000,
            tip_total: -100, // Tip adjustment/refund
            discounts_total: 0,
            tax_total: 80,
            grand_total: 980, // 1000 - 100 + 80
            fees_total: 0
        };
        
        Assert.equals(1000, totals.subtotal);
        Assert.equals(-100, totals.tip_total);
        Assert.equals(0, totals.discounts_total);
        Assert.equals(80, totals.tax_total);
        Assert.equals(980, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsLargeValues() {
        // Test with large monetary values (catering orders, etc.)
        var totals: OrderTotals = {
            subtotal: 50000, // $500.00
            tip_total: 10000, // $100.00
            discounts_total: 5000, // $50.00
            tax_total: 4000, // $40.00
            grand_total: 59000, // $590.00
            fees_total: 0
        };
        
        Assert.equals(50000, totals.subtotal);
        Assert.equals(10000, totals.tip_total);
        Assert.equals(5000, totals.discounts_total);
        Assert.equals(4000, totals.tax_total);
        Assert.equals(59000, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
    
    function testOrderTotalsMaxIntValues() {
        // Test with maximum integer values (edge case)
        var totals: OrderTotals = {
            subtotal: 2147483647, // Max int value
            tip_total: 0,
            discounts_total: 0,
            tax_total: 0,
            grand_total: 2147483647,
            fees_total: 0
        };
        
        Assert.equals(2147483647, totals.subtotal);
        Assert.equals(0, totals.tip_total);
        Assert.equals(0, totals.discounts_total);
        Assert.equals(0, totals.tax_total);
        Assert.equals(2147483647, totals.grand_total);
        Assert.equals(0, totals.fees_total);
    }
}