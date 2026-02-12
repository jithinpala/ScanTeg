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
            VStack {
                Text(DashBoardStrings.welcomeTitle)
                    .font(.headline)
                Spacer()
            }
        case .loading:
            ProgressLoadingView()
        case .locationAuthorized:
            Text(DashBoardStrings.locationAuthorized)
                .onAppear {
                    Task {
                        await viewModel.getData()
                    }
                }
        case .locationDenied:
            locationAccessDeniedView
        case let .venueLoaded(dashboardResponse):
            showVenueList(for: dashboardResponse)
        case .failed:
            VStack {
                Text(DashBoardStrings.somethingWentWrong)
                    .font(.headline)
                    .padding(.vertical, DesignSystem.Spacing.medium)
                Text(DashBoardStrings.pleaseTryAgain)
                
                Button(DashBoardStrings.retryButtonTitle) {
                    Task {
                        await viewModel.getData()
                    }
                }
                .padding(.top, DesignSystem.Spacing.medium)
            }
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
                .navigationTitle(DashBoardStrings.dashboardTitle)
                .navigationDestination(for: VenueDetailsViewModel.self) { venue in
                    let viewModel = TicketScanViewModel(venueDetails: venue)
                    TicketScanView(viewModel: viewModel)
                }
        }
    }

    private func makeTileView(for title: String) -> some View {
        VStack {
            Image("mobile_scan_icon")
                .resizable()
                .scaledToFit()
                .frame(width: DesignSystem.IconSize.medium, height: DesignSystem.IconSize.medium)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(DesignSystem.Spacing.medium)
        .overlay {
            RoundedRectangle(cornerRadius: DesignSystem.Spacing.small)
                .stroke(Color.gray, lineWidth: DesignSystem.LineWidth.small)
        }
        .padding(DesignSystem.Spacing.small)
        .frame(maxWidth: .infinity)
    }

    private var locationAccessDeniedView: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.zero) {
            Image(systemName: "location.fill")
                .resizable()
                .scaledToFit()
                .frame(width: DesignSystem.Spacing.xxxLarge, height: DesignSystem.Spacing.xxxLarge)
            Text(DashBoardStrings.locationPermissionDenied)
                .font(.headline)
                .padding(.top, DesignSystem.Spacing.medium)
            Text(DashBoardStrings.openSettingForLocationTitle)
                .padding(.top, DesignSystem.Spacing.small)
                .foregroundColor(.secondary)
            Button(DashBoardStrings.settingButtonTitle) {
                openAppSettings()
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
    }

    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

#Preview {
    DashBoardView()
}
