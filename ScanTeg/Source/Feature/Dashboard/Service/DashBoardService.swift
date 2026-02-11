//
//  DashBoardService.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Foundation

protocol DashBoardServiceProtocol {
    func fetchDashboardData(latitude: Double, longitude: Double) async throws -> DashboardResponse
    func validateTicket(for venueCode: String, barcode: String) async throws -> TicketScanResult
}

final class DashBoardService: DashBoardServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    enum DashboardEndPoints: EndpointProvider {
        static var baseEndpoint = "/venues"
        static func getVenues(for latitude: Double, longitude: Double) -> String {
            urlString(withEndPoint: "/?latitude=\(latitude)&longitude=\(longitude)")
        }
        static func validateTicketEndPoint(for venueCode: String) -> String {
            urlString(withEndPoint: "/\(venueCode)/pax/entry/scan")
        }
    }
        
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchDashboardData(latitude: Double, longitude: Double) async throws -> DashboardResponse {
        let endpoint = DashboardEndPoints.getVenues(for: latitude, longitude: longitude)
        return try await networkManager.request(baseURL: endpoint, method: .get)
    }

    func validateTicket(for venueCode: String, barcode: String) async throws -> TicketScanResult {
        let requestBody = ["barcode": barcode]
        let endPoint = DashboardEndPoints.validateTicketEndPoint(for: venueCode)
        return try await networkManager.request(
            baseURL: endPoint,
            method: .post,
            body: requestBody
        )
    }
}


