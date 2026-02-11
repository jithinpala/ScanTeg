//
//  VenueDeatilsViewModel.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

struct VenueDetailsViewModel: Identifiable, Hashable {
    let code: String
    let name: String
    let address: String?
    
    var id: String {
        "\(code) + \(name)"
    }
}
