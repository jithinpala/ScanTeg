//
//  DashBoardService.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Foundation

protocol DashBoardServiceProtocol {
    func fetchDashboardData(latitude: Double, longitude: Double) async throws -> DashboardResponse
}

final class DashBoardService: DashBoardServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    enum DashboardEndPoints: EndpointProvider {
        static var baseEndpoint = "/venues"
        static func getVenues(for latitude: Double, longitude: Double) -> String {
            urlString(withEndPoint: "/?latitude=\(latitude)&longitude=\(longitude)")
        }
    }
        
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchDashboardData(latitude: Double, longitude: Double) async throws -> DashboardResponse {
        let endpoint = DashboardEndPoints.getVenues(for: latitude, longitude: longitude)
        return try await networkManager.request(baseURL: endpoint, method: .get)
    }
}    
