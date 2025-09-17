package spoton.models.onboarding;

/**
 * Represents a location candidate for onboarding
 */
typedef LocationCandidate = {
    /**
     * The unique identifier for the location
     */
    var location_id: String;
    
    /**
     * The name of the location
     */
    var name: String;
    
    /**
     * Whether the location is eligible for onboarding
     */
    var eligible: Bool;
}