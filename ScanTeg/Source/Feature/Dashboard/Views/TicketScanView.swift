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

    private enum Constants {
        static let cameraViewHeight: CGFloat = 500
        static let timerDelay: UInt64 = 5_000_000_000
    }

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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.zero) {
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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.zero) {
            Text(DashBoardStrings.scanBarcodeMessage)
                .font(.headline)
                .padding()
            CameraPreviewView(session: viewModel.getSession())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: Constants.cameraViewHeight)
        }
    }

    private var failedView: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.zero) {
            Image("networkFailureIcon")
                .resizable()
                .scaledToFit()
                .frame(width: DesignSystem.IconSize.medium, height: DesignSystem.IconSize.medium)
            Text(DashBoardStrings.somethingWentWrong)
                .font(.title3)
                .padding(.top, DesignSystem.Spacing.medium)
            Text(DashBoardStrings.pleaseTryAgain)
                .padding(.top, DesignSystem.Spacing.small)
            
            Button(action: {
                viewModel.tryAgain()
            }) {
                Text(DashBoardStrings.retryButtonTitle)
            }
            .padding(DesignSystem.Spacing.medium)
        }
    }

    private func validationResultView(for status: String) -> some View {
        VStack(alignment: .center, spacing: DesignSystem.Spacing.zero) {
            let imageName = status == "SUCCESS" ? "successTicketIcon" : ""
            
            HStack(alignment: .center) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: DesignSystem.IconSize.medium, height: DesignSystem.IconSize.medium)
            }
            Text(DashBoardStrings.validationMessageTitle)
                .font(.title3)
                .padding(.top, DesignSystem.Spacing.medium)
            Text(ticketStatusMessage(for: status))
                .padding(.top, DesignSystem.Spacing.small)
        }
        .onAppear {
            startTimer()
        }
    }

    private var cameraAccessDeniedView: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.zero) {
            Image(systemName: "camera.fill")
                .resizable()
                .scaledToFit()
                .frame(width: DesignSystem.IconSize.medium, height: DesignSystem.IconSize.medium)
            Text(DashBoardStrings.cameraAccessDeniedTitle)
                .font(.headline)
                .padding(.top, DesignSystem.Spacing.medium)
            Text(DashBoardStrings.openSettingTitle)
                .padding(.top, DesignSystem.Spacing.small)
                .foregroundColor(.secondary)
            Button(DashBoardStrings.settingButtonTitle) {
                openAppSettings()
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical, DesignSystem.Spacing.medium)
        }
    }

    private func startTimer() {
        cancelTimer()
        timerTask = Task {
            try? await Task.sleep(nanoseconds: Constants.timerDelay)
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
