//
//  TicketScanViewModel.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Combine
import Foundation
import AVFoundation

@MainActor
final class TicketScanViewModel: ObservableObject {
    let venueDetails: VenueDetailsViewModel
    let manager: DashBoardServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var scannedBarcode: String?
    @Published var scannerViewModel = BarcodeScannerViewModel()
    @Published var state: ViewState = .requestAccess
    let cameraManager = CameraPermissionManager()
        
    enum ViewState {
        case scanning
        case loading
        case ticketValidated(String)
        case failed
        case cameAccessDenied
        case requestAccess
    }
    
    init(
        venueDetails: VenueDetailsViewModel,
        manager: DashBoardServiceProtocol = DashBoardService()
    ) {
        self.venueDetails = venueDetails
        self.manager = manager
        setupBinding()
    }
    
    private func setupBinding() {
        scannerViewModel.$scannedCode
            .sink { [weak self] barcode in
                guard let code = barcode else { return }
                self?.scannedBarcode = code
                self?.scanTicket(for: code)
            }
            .store(in: &cancellables)

        cameraManager.$permissionStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.updateState(for: status)
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func updateState(for status: CameraPermissionManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            state = .scanning
            startScanning()
        case .notDetermined:
            // TODO: Need to revisit this.
            print("Already requested for access")
        case .denied:
            state = .cameAccessDenied
        }
    }

    func scanTicket(for barCode: String) {
        state = .loading
        Task { @MainActor in
            do {
                let result = try await manager.validateTicket(for: venueDetails.code, barcode: barCode)
                state = .ticketValidated(result.result)
            } catch {
                state = .failed
            }
        }
    }
    
    func getSession() -> AVCaptureSession {
        scannerViewModel.getSession()
    }

    func startScanning() {
        scannerViewModel.startScanning()
    }

    func stopScanning() {
        scannerViewModel.stopScanning()
    }

    func tryAgain() {
        guard let code = scannedBarcode else { return }
        scanTicket(for: code)
    }

    func requestAccessPermission() {
        cameraManager.requestCameraPermission()
    }
}
