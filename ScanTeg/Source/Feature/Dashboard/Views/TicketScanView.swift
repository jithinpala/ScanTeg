//
//  TicketScanView.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Combine
import SwiftUI
import AVFoundation

struct TicketScanView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: TicketScanViewModel
    @State private var timerTask: Task<Void, Never>?

    var body: some View {
        VStack {
            switch viewModel.state {
            case .requestAccess:
                welcomeView
            case .scanning:
                cameraView
            case .loading:
                ProgressLoadingView()
            case .failed:
                failedView
            case let .ticketValidated(status):
                validationResultView(for: status)
            case .cameAccessDenied:
                cameraAccessDeniedView
            }
        }
        .onDisappear {
            cancelTimer()
            viewModel.stopScanning()
        }
    }

    private var welcomeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(DashBoardStrings.cameraAccessTitle)
                .font(.headline)
                .padding()
            Spacer()
        }
        .onAppear {
            viewModel.requestAccessPermission()
        }
    }

    private var cameraView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(DashBoardStrings.scanBarcodeMessage)
                .font(.headline)
                .padding()
            CameraPreviewView(session: viewModel.getSession())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 500)
        }
    }

    private var failedView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image("networkFailureIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            Text(DashBoardStrings.somethingWentWrong)
                .font(.title3)
                .padding(.top, 16)
            Text(DashBoardStrings.pleaseTryAgain)
                .padding(.top, 8)
            
            Button(action: {
                viewModel.tryAgain()
            }) {
                Text(DashBoardStrings.retryButtonTitle)
            }
            .padding(16)
        }
    }

    private func validationResultView(for status: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            let imageName = status == "SUCCESS" ? "successTicketIcon" : ""
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            Text(DashBoardStrings.validationMessageTitle)
                .font(.title3)
                .padding(.top, 16)
            Text(ticketStatusMessage(for: status))
                .padding(.top, 8)
        }
        .onAppear {
            startTimer()
        }
    }

    private var cameraAccessDeniedView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: "camera.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
            Text(DashBoardStrings.cameraAccessDeniedTitle)
                .font(.headline)
                .padding(.top, 16)
            Text(DashBoardStrings.openSettingTitle)
                .padding(.top, 8)
                .foregroundColor(.secondary)
            Button(DashBoardStrings.settingButtonTitle) {
                openAppSettings()
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 16)
        }
    }

    private func startTimer() {
        cancelTimer()
        timerTask = Task {
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            guard !Task.isCancelled else { return }
            await MainActor.run {
                dismiss()
            }
        }
    }

    private func cancelTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    private func ticketStatusMessage(for status: String) -> String {
        String(format: DashBoardStrings.ticketStatusTitle, status)
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
