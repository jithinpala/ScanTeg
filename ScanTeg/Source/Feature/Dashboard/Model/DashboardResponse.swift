//
//  DashboardResponse.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

struct DashboardResponse: Decodable {
    let venues: [VenueDetails]?
    let singleVenue: VenueDetails?
    let paxLocation: PaxLocation?
    
    enum ResponseType {
        case venues([VenueDetails])
        case singleVenue(VenueDetails)
        case paxLocation(PaxLocation)
        case unknown
    }
    
    var responseType: ResponseType {
        if let venues = venues {
            return .venues(venues)
        } else if let singleVenue = singleVenue {
            return .singleVenue(singleVenue)
        } else if let paxLocation = paxLocation {
            return .paxLocation(paxLocation)
        }
        return .unknown
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        
        // Check if "venues" key exists - this indicates array response
        if container.contains(.venues) {
            let venuesArray = try container.decode([VenueDetails].self, forKey: .venues)
            self.venues = venuesArray
            self.singleVenue = nil
            self.paxLocation = nil
            return
        }
        
        // Check if "code" key exists - this indicates a VenueDetails object
        if container.contains(.code) {
            let singleVenue = try VenueDetails(from: decoder)
            self.venues = nil
            self.singleVenue = singleVenue
            self.paxLocation = nil
            return
        }
        
        // Check if "name" and "gates" keys exist - this indicates a PaxLocation object
        if container.contains(.name) && container.contains(.gates) {
            let paxLocation = try PaxLocation(from: decoder)
            self.venues = nil
            self.singleVenue = nil
            self.paxLocation = paxLocation
            return
        }
        
        // If none of the above patterns match, initialize with nil values
        self.venues = nil
        self.singleVenue = nil
        self.paxLocation = nil
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
        
        static let venues = DynamicCodingKeys(stringValue: "venues")!
        static let code = DynamicCodingKeys(stringValue: "code")!
        static let name = DynamicCodingKeys(stringValue: "name")!
        static let gates = DynamicCodingKeys(stringValue: "gates")!
    }
    
}
