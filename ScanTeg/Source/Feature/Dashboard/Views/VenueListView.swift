//
//  VenueListView.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import SwiftUI

struct VenueListView: View {
    @ObservedObject var viewModel: VenueListViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.zero) {
            if !viewModel.venues.isEmpty {
                ScrollView {
                    LazyVStack(spacing: DesignSystem.Spacing.zero) {
                        ForEach(viewModel.venues) { venue in
                            makeVenueRow(venue)
                        }
                    }
                }
            } else {
                showErrorView()
            }
        }
        .onAppear {
            viewModel.getVenueList()
        }
    }

    private func makeVenueRow(_ venue: VenueDetailsViewModel) -> some View {
        Button {
            viewModel.venueTapAction(for: venue)
        } label: {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text(venue.name)
                    .font(.headline)
                    .foregroundColor(.black)
                if let address = venue.address {
                    Text(address)
                        .foregroundColor(.black)
                        .padding(.leading, DesignSystem.Spacing.extraSmall)
                }
            }
            .padding(DesignSystem.Spacing.small)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay{
                RoundedRectangle(cornerRadius: DesignSystem.Spacing.small)
                    .stroke(Color.gray, lineWidth: DesignSystem.LineWidth.medium)
            }
        }

    }

    private func showErrorView() -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(DashBoardStrings.somethingWentWrong)
                .font(.title3)
            Text(DashBoardStrings.pleaseTryAgain)
        }
    }
}
