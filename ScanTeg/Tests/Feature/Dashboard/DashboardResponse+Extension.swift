//
//  DashboardResponse+Extension.swift
//  ScanTeg
//
//  Created by Jithin Balan on 11/2/2026.
//

import Foundation

@testable import ScanTeg

extension DashboardResponse {
    static func dashboardResponseForSingleVenue() -> DashboardResponse {
        let sampleData = """
        {
            "code": "AEC",
            "name": "Adelaide Entertainment Centre",
            "address": "Corner Port Road and Adam Street",
            "city": "Hindmarsh",
            "state": "SA",
            "postcode": "5007",
            "latitude": -34.9098,
            "longitude": 138.57081,
            "timezone": "9.50",
            "pax_locations": [
                {
                    "name": "CENTRE",
                    "gates": [
                        {
                            "name": "A"
                        },
                        {
                            "name": "B"
                        },
                        {
                            "name": "C"
                        }
                    ]
                }
            ]
        } 
        """
        let decoder = JSONDecoder()
        guard let data = sampleData.data(using: .utf8) else {
            fatalError("Couldn't convert sample string to data")
        }
        return try! decoder.decode(DashboardResponse.self, from: data)
    }

    static func dashboardResponseForVenue() -> DashboardResponse {
        let sampleData = """
        {
            "venues": [
                {
                    "code": "AEC",
                    "name": "Adelaide Entertainment Centre",
                    "address": "Corner Port Road and Adam Street",
                    "city": "Hindmarsh",
                    "state": "SA",
                    "postcode": "5007",
                    "latitude": -34.9098,
                    "longitude": 138.57081,
                    "timezone": "9.50",
                    "pax_locations": [
                        {
                            "name": "CENTRE",
                            "gates": [
                                {
                                    "name": "A"
                                },
                                {
                                    "name": "B"
                                },
                                {
                                    "name": "C"
                                }
                            ]
                        }
                    ]
                },
                {
                    "code": "AEC",
                    "name": "Adelaide Entertainment Centre",
                    "address": "Corner Port Road and Adam Street",
                    "city": "Hindmarsh",
                    "state": "SA",
                    "postcode": "5007",
                    "latitude": -34.9098,
                    "longitude": 138.57081,
                    "timezone": "9.50",
                    "pax_locations": [
                        {
                            "name": "CENTRE",
                            "gates": [
                                {
                                    "name": "A"
                                },
                                {
                                    "name": "B"
                                },
                                {
                                    "name": "C"
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        """
        let decoder = JSONDecoder()
        guard let data = sampleData.data(using: .utf8) else {
            fatalError("Couldn't convert sample string to data")
        }
        return try! decoder.decode(DashboardResponse.self, from: data)
    }
}
