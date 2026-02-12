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

    enum ViewState {
        case scanning
        case loading
        case ticketValidated(String)
        case failed
        case cameAccessDenied
        case requestAccess
    }

    let venueDetails: VenueDetailsViewModel
    let manager: DashBoardServiceProtocol
    let cameraManager = CameraPermissionManager()
    private var cancellables = Set<AnyCancellable>()
    private var scannedBarcode: String?
    private var scannerManager: BarcodeScannerManagerProtocol
    @Published var state: ViewState = .requestAccess

    init(
        venueDetails: VenueDetailsViewModel,
        manager: DashBoardServiceProtocol = DashBoardService(),
        scannerManager: BarcodeScannerManagerProtocol = BarcodeScannerManager()
    ) {
        self.venueDetails = venueDetails
        self.manager = manager
        self.scannerManager = scannerManager
        setupBinding()
    }
    
    private func setupBinding() {
        scannerManager.scannedCode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] barcode in
                self?.scannedBarcode = barcode
                self?.scanTicket(for: barcode)
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
        scannerManager.getSession()
    }

    func startScanning() {
        scannerManager.startScanning()
    }

    func stopScanning() {
        scannerManager.stopScanning()
    }

    func tryAgain() {
        guard let code = scannedBarcode else { return }
        scanTicket(for: code)
    }

    func requestAccessPermission() {
        cameraManager.requestCameraPermission()
    }
}
