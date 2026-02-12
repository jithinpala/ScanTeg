//
//  MockBarcodeScannerManager.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 12/2/2026.
//

import AVFoundation
import Combine
import Testing
@testable import ScanTeg

final class MockBarcodeScannerManager: BarcodeScannerManagerProtocol {

    private let scannedCodeSubject: CurrentValueSubject<String, Never>
    var didStartScanning = false
    var didStopScanning = false

    var scannedCode: AnyPublisher<String, Never> {
        scannedCodeSubject.eraseToAnyPublisher()
    }

    init() {
        scannedCodeSubject = CurrentValueSubject("")
    }
    
    func startScanning() {
        didStartScanning = true
    }
    
    func stopScanning() {
        didStopScanning = true
    }
    
    func getSession() -> AVCaptureSession {
        AVCaptureSession()
    }
}
