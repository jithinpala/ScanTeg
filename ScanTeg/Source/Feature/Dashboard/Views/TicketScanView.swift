//
//  TicketScanView.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import SwiftUI

struct TicketScanView: View {
    let viewModel: VenueDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Hello, World!")
            Button("Back") {
                dismiss()
            }
        }
        .navigationTitle("Scan Ticket")
        .navigationBarTitleDisplayMode(.inline)
    }
}
