//
//  TicketScanResult.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

struct TicketScanResult: Decodable {
    let status: String
    let action: String
    let result: String
    let concession: Int
}

struct TicketScanRequest: Encodable {
    let barcode: String
}
