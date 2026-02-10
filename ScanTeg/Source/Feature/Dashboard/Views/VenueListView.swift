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
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.venues.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 0) {
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
            viewModel.parseResult()
        }
    }

    private func makeVenueRow(_ venue: VenueDetailsViewModel) -> some View {
        Button {
            viewModel.venueTapAction(for: venue)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(venue.name)
                    .font(.headline)
                    .foregroundColor(.black)
                if let address = venue.address {
                    Text(address)
                        .foregroundColor(.black)
                        .padding(.leading, 4)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay{
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 2)
            }
        }

    }

    private func showErrorView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Something went wrong.")
                .font(.title3)
            Text("Please try again later.")
        }
    }
}
