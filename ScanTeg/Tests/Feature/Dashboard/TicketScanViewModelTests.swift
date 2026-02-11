//
//  TicketScanViewModelTests.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 11/2/2026.
//

import Testing
@testable import ScanTeg

struct TicketScanViewModelTests {

    @Test
    func scanTicketWithLoadingState() async throws {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockPath = "ticketScanResult"
        let dashBoardService = DashBoardService(networkManager: mockNetworkManager)
        
        let venueDetailsViewModel = VenueDetailsViewModel(code: "ABC", name: "Sydney", address: "Sydney NSW")
        let viewModel = await makeViewModel(venueDetails: venueDetailsViewModel, manager: dashBoardService)
        await viewModel.scanTicket(for: "ABC")

        guard case .loading = await viewModel.state else {
            Issue.record("Expected state to be loading")
            return
        }
    }

    @Test
    func scanTicketWithValidatedState() async throws {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockPath = "ticketScanResult"
        let dashBoardService = DashBoardService(networkManager: mockNetworkManager)
        
        let venueDetailsViewModel = VenueDetailsViewModel(code: "ABC", name: "Sydney", address: "Sydney NSW")
        let viewModel = await makeViewModel(venueDetails: venueDetailsViewModel, manager: dashBoardService)
        await viewModel.scanTicket(for: "ABC")
        
        // Wait 1 second to change get the result, state will change from `loading` to
        // `ticketValidated`
        try await Task.sleep(for: .seconds(1))
        
        guard case let .ticketValidated(result) = await viewModel.state else {
            Issue.record("Expected state to be venueLoaded with single venue")
            return
        }
        #expect(result == "SUCCESS")
    }

    @MainActor
    private func makeViewModel(
        venueDetails: VenueDetailsViewModel,
        manager: DashBoardServiceProtocol = MockDashBoardService()
    ) -> TicketScanViewModel {
        TicketScanViewModel(venueDetails: venueDetails, manager: manager)
    }
}
