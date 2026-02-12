//
//  MockDashBoardService.swift
//  ScanTeg
//
//  Created by Jithin Balan on 11/2/2026.
//

import Foundation
@testable import ScanTeg

final class MockDashBoardService: DashBoardServiceProtocol {
    var shouldSucceed = true
    var mockResponse: DashboardResponse?
    
    func fetchDashboardData(latitude: Double, longitude: Double) async throws -> DashboardResponse {
        if shouldSucceed {
            if let response = mockResponse {
                return response
            }
            return try DashboardResponse.dashboardResponseForSingleVenue()
        } else {
            throw NetworkError(errorCode: "TEST_ERROR", message: "Test error")
        }
    }

    func validateTicket(for venueCode: String, barcode: String) async throws -> TicketScanResult {
        TicketScanResult(status: "", action: "", result: "", concession: 1)
    }
}
