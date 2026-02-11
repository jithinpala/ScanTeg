//
//  VenueDetails.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

struct VenueDetails: Decodable {
    let code: String?
    let name: String?
    let address: String?
    let city: String?
    let state: String?
    let postcode: String?
    let latitude: Double?
    let longitude: Double?
    let timezone: String?
    let paxLocations: [PaxLocation]?
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case address
        case city
        case state
        case postcode
        case latitude
        case longitude
        case timezone
        case paxLocations = "pax_locations"
    }
}
