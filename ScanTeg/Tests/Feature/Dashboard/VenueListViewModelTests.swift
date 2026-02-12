//
//  VenueListViewModelTests.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 11/2/2026.
//

import Testing
@testable import ScanTeg

struct VenueListViewModelTests {
    @Test
    func getVenueListForSingleVenue() async throws {
        let dashboardResponse = try DashboardResponse.dashboardResponseForSingleVenue()
        let viewModel = makeVenueListViewModel(dashboardResponse: dashboardResponse) { _ in }
        viewModel.getVenueList()
        
        #expect(viewModel.venues.count == 1)
    }

    @Test
    func getVenueList() async throws {
        let dashboardResponse = try DashboardResponse.dashboardResponseForVenue()
        let viewModel = makeVenueListViewModel(dashboardResponse: dashboardResponse) { _ in }
        viewModel.getVenueList()
        
        #expect(viewModel.venues.count == 2)
    }

    @Test
    func getVenueListActionHandler() async throws {
        try await confirmation(expectedCount: 1) { confirm in
            let dashboardResponse = try DashboardResponse.dashboardResponseForSingleVenue()
            let viewModel = makeVenueListViewModel(dashboardResponse: dashboardResponse) { venueDetails in
                #expect(venueDetails.code == "AEC")
                #expect(venueDetails.name == "Adelaide Entertainment Centre")
                confirm()
            }
            viewModel.getVenueList()
            let venueDetails = viewModel.venues[0]
            viewModel.venueTapAction(for: venueDetails)
        }
    }

    private func makeVenueListViewModel(
        dashboardResponse: DashboardResponse,
        actionHandler: @escaping (VenueDetailsViewModel) -> Void
    ) -> VenueListViewModel {
        VenueListViewModel(dashboardResponse: dashboardResponse, actionHandler: actionHandler)
    }
}
