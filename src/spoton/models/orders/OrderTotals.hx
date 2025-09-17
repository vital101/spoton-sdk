package spoton.models.orders;

/**
 * OrderTotals typedef representing the financial totals for an order
 * All monetary values are represented in cents as integers
 */
typedef OrderTotals = {
    /**
     * Subtotal amount before taxes, tips, discounts, and fees (in cents)
     */
    var subtotal: Int;
    
    /**
     * Total tip amount (in cents)
     */
    var tip_total: Int;
    
    /**
     * Total discount amount applied (in cents)
     */
    var discounts_total: Int;
    
    /**
     * Total tax amount (in cents)
     */
    var tax_total: Int;
    
    /**
     * Final grand total amount (in cents)
     */
    var grand_total: Int;
    
    /**
     * Total fees amount (in cents)
     */
    var fees_total: Int;
}