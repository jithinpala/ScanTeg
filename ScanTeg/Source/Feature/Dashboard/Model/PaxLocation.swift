//
//  PaxLocation.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

struct PaxLocation: Decodable {
    let name: String?
    let gates: [Gate]?
}

struct Gate: Decodable {
    let name: String?
}
