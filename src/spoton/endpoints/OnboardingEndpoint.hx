package spoton.endpoints;

import spoton.http.HTTPClient;
import spoton.auth.AuthenticationManager;
import spoton.models.onboarding.LocationCandidate;
import spoton.errors.SpotOnException;

/**
 * OnboardingEndpoint provides access to SpotOn's Onboarding API endpoints.
 * This includes OAuth2 location authorization and location candidate management.
 */
class OnboardingEndpoint extends BaseEndpoint {
    
    /**
     * Creates a new OnboardingEndpoint instance
     * @param httpClient HTTP client for making requests
     * @param auth Authentication manager for handling auth headers
     */
    public function new(httpClient: HTTPClient, auth: AuthenticationManager) {
        super(httpClient, auth);
    }
    
    /**
     * Retrieves all location candidates available for onboarding
     * @param callback Callback function that receives an array of LocationCandidate objects
     * @throws SpotOnException if the request fails
     */
    public function listLocationCandidates(callback: Array<LocationCandidate> -> Void): Void {
        // Construct the API path
        var path = '/onboarding/v1/location-candidates';
        
        // Make the GET request
        makeRequest("GET", path, null, function(response: Dynamic): Void {
            try {
                // Parse the response into an array of LocationCandidate objects
                var candidates: Array<LocationCandidate> = [];
                
                if (response != null) {
                    // Handle both array response and object with data property
                    var candidateData: Array<Dynamic> = null;
                    
                    if (Std.isOfType(response, Array)) {
                        candidateData = cast response;
                    } else if (response.data != null && Std.isOfType(response.data, Array)) {
                        candidateData = cast response.data;
                    } else if (response.location_candidates != null && Std.isOfType(response.location_candidates, Array)) {
                        candidateData = cast response.location_candidates;
                    } else if (response.candidates != null && Std.isOfType(response.candidates, Array)) {
                        candidateData = cast response.candidates;
                    }
                    
                    if (candidateData != null) {
                        for (candidateItem in candidateData) {
                            if (candidateItem != null) {
                                var candidate: LocationCandidate = {
                                    location_id: candidateItem.location_id != null ? candidateItem.location_id : "",
                                    name: candidateItem.name != null ? candidateItem.name : "",
                                    eligible: candidateItem.eligible != null ? candidateItem.eligible : false
                                };
                                candidates.push(candidate);
                            }
                        }
                    }
                }
                
                // Call the callback with the parsed location candidates
                callback(candidates);
                
            } catch (e: Dynamic) {
                throw new SpotOnException("Failed to parse location candidates response: " + Std.string(e), "LOCATION_CANDIDATES_PARSE_ERROR", e);
            }
        });
    }
}