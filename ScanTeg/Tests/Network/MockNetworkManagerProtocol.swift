//
//  MockNetworkManagerProtocol.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 11/2/2026.
//

import Foundation

@testable import ScanTeg

protocol MockNetworkManagerProtocol: AnyObject, NetworkManagerProtocol {
    var bundle: Bundle { get }
    var mockPath: String? { get set }
    var mockJSON: [String: Any]? { get set }
    func loadJSON() throws -> Data
}

extension MockNetworkManagerProtocol {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    var mockPath: String? { return nil }
    var mockJSON: [String: Any]? { return nil }

    func loadJSON() throws -> Data {
        if let filename = mockPath {
            return try readData(filename)
        } else if let mockJSON = mockJSON {
            return try JSONSerialization.data(withJSONObject: mockJSON, options: [])
        } else {
            throw NetworkError(errorCode: "404", message: "⚙️ Mock file or mock JSON is not found on location")
        }
    }

    private func readData(_ path: String) throws -> Data {
        guard let path = bundle.url(forResource: path, withExtension: "json") else {
            throw NetworkError(errorCode: "404", message: "⚙️ \(path) is not found on location")
        }
        
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            throw NetworkError(errorCode: "404", message: "⚙️ \(path) is not found on location")
        }
    }
}
