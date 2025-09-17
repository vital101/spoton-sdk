package spoton.models.business;

import spoton.models.common.Address;
import spoton.models.common.Geolocation;

/**
 * Location model representing a SpotOn business location
 */
typedef Location = {
    var id: String;
    var name: String;
    var email: String;
    var phone: String;
    var address: Address;
    var geolocation: Geolocation;
    var timezone: String;
}