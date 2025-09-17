package spoton.models.common;

/**
 * Address model for location and customer addresses
 */
typedef Address = {
    var address_line_1: String;
    var city: String;
    var state: String;
    var zip: String;
    var country: String;
}