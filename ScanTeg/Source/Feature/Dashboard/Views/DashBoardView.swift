//
//  DashBoardView.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import SwiftUI

struct DashBoardView: View {
    @StateObject var viewModel = DashBoardViewModel()
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            Text("Idle State")
                .onAppear {
                    viewModel.getLocationAuthorization()
                }
        case .loading:
            ProgressView()
        case .locationAuthorized:
            Text("We got the location")
                .onAppear {
                    Task {
                        await viewModel.getData()
                    }
                }
        case .locationDenied:
            Text("Location permission denied. Please enable location services in settings.")
        case let .venueLoaded(dashboardResponse):
            showVenueList(for: dashboardResponse)
        case .failed:
            Text("Failed to load data. Please try again.")
        }
    }

    private func showVenueList(for dashboardResponse: DashboardResponse) -> some View {
        NavigationStack(path: $navigationPath) {
            let venueListViewModel = VenueListViewModel(
                dashboardResponse: dashboardResponse,
                actionHandler: { venueViewModel in
                    navigationPath.append(venueViewModel)
                })
            VenueListView(viewModel: venueListViewModel)
                .padding()
                .navigationTitle("Venue List")
                .navigationDestination(for: VenueDetailsViewModel.self) { venue in
                    TicketScanView(viewModel: venue)
                }
        }
    }

    private func makeTileView(for title: String) -> some View {
        VStack {
            Image("mobile_scan_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(18)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashBoardView()
}
