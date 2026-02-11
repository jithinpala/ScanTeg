//
//  Endpoints.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Foundation

protocol EndpointProvider {
    static var baseEndpoint: String { get }
    static func urlString(withEndPoint endpoint: String) -> String
}

extension EndpointProvider {
    static func urlString(withEndPoint endpoint: String) -> String {
        let values = [baseEndpoint, endpoint]
        return values.reduce("") { result, value in
            guard !value.isEmpty else { return result }
            return (result as NSString).appendingPathComponent(value)
        }
    }

}
