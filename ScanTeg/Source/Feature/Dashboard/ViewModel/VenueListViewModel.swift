//
//  VenueDetailsViewModel.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

final class VenueListViewModel: ObservableObject {
    private let dashboardResponse: DashboardResponse
    private let actionHandler: (_ viewModel: VenueDetailsViewModel) -> Void
    @Published var venues: [VenueDetailsViewModel] = []
    
    init(
        dashboardResponse: DashboardResponse,
        actionHandler: @escaping (_ viewModel: VenueDetailsViewModel) -> Void
    ) {
        self.dashboardResponse = dashboardResponse
        self.actionHandler = actionHandler
    }

    func parseResult() {
        let type = dashboardResponse.responseType
        switch type {
        case let .venues(items):
            venues = items.compactMap { venue -> VenueDetailsViewModel? in
                guard let code = venue.code, let name = venue.name else {
                    return nil
                }
                return VenueDetailsViewModel(code: code, name: name, address: venue.address)
            }
        case let .singleVenue(singleVenue):
            guard let code = singleVenue.code, let name = singleVenue.name else {
                return
            }
            venues = [VenueDetailsViewModel(code: code, name: name, address: singleVenue.address)]
        case .paxLocation, .unknown:
            // TODO: pax location doesn't have venue code, so we can't trigger scan ticket with venue code
            // Need revisit this
            venues = []
        }
    }

    func venueTapAction(for viewModel: VenueDetailsViewModel) {
        actionHandler(viewModel)
    }
}
