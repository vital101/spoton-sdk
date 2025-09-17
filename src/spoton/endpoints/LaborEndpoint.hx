package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.models.labor.Employee;
import spoton.errors.SpotOnException;

/**
 * LaborEndpoint provides access to SpotOn's Labor API endpoints.
 * This includes employee management, time punches, jobs, and breaks.
 * Note: Labor API is only available for SpotOn EXPRESS locations.
 */
class LaborEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new LaborEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Retrieves all employees for a specific location
     * Note: This endpoint is only available for SpotOn EXPRESS locations
     * @param locationId The location ID to get employees for
     * @param callback Callback function that receives an array of Employee objects
     * @throws SpotOnException if the request fails or parameters are invalid
     */
    public function getEmployees(locationId: String, callback: Array<Employee> -> Void): Void {
        // Validate required parameters
        if (locationId == null || locationId.length == 0) {
            throw new SpotOnException("Location ID is required", "INVALID_LOCATION_ID");
        }
        
        // Construct the API path
        var path = '/labor/v1/locations/${locationId}/employees';
        
        // Make the GET request
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            try {
                // Parse the response into an array of Employee objects
                var employees: Array<Employee> = [];
                
                if (response != null) {
                    // Handle both array response and object with data property
                    var employeeData: Array<Dynamic> = null;
                    
                    if (Std.isOfType(response, Array)) {
                        employeeData = cast response;
                    } else if (response.data != null && Std.isOfType(response.data, Array)) {
                        employeeData = cast response.data;
                    } else if (response.employees != null && Std.isOfType(response.employees, Array)) {
                        employeeData = cast response.employees;
                    }
                    
                    if (employeeData != null) {
                        for (empItem in employeeData) {
                            if (empItem != null) {
                                var employee: Employee = {
                                    id: empItem.id,
                                    first_name: empItem.first_name != null ? empItem.first_name : "",
                                    last_name: empItem.last_name != null ? empItem.last_name : "",
                                    email: empItem.email != null ? empItem.email : "",
                                    status: empItem.status != null ? empItem.status : ""
                                };
                                employees.push(employee);
                            }
                        }
                    }
                }
                
                // Call the callback with the parsed employees
                callback(employees);
                
            } catch (e: Dynamic) {
                throw new SpotOnException("Failed to parse employees response: " + Std.string(e), "EMPLOYEES_PARSE_ERROR", e);
            }
        });
    }
}