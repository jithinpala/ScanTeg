//
//  ProgressLoadingView.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import SwiftUI

struct ProgressLoadingView: View {
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .padding(30)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}

#Preview {
    ProgressLoadingView()
}
