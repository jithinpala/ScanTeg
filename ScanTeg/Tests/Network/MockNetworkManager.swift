//
//  MockNetworkManager.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 11/2/2026.
//

import Foundation
@testable import ScanTeg

final class MockNetworkManager: MockNetworkManagerProtocol {
    var mockPath: String?
    var mockJSON: [String : Any]?

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    func request<T: Decodable>(
        baseURL: String? = nil,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: [String: Any]? = nil
    ) async throws -> T {
        do {
            let data =  try loadJSON()
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw NetworkError(errorCode: "404", message: "⚙️ Failed to process request on mock")
        }
    }
}
