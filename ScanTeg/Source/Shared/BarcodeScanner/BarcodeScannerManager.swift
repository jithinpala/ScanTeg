//
//  BarcodeScannerManager.swift
//  ScanTeg
//
//  Created by Jithin Balan on 12/2/2026.
//

import Foundation
import AVFoundation
import Combine

protocol BarcodeScannerManagerProtocol {
    var scannedCode: AnyPublisher<String, Never> { get }

    func startScanning()
    func stopScanning()
    func getSession() -> AVCaptureSession
}

final class BarcodeScannerManager: NSObject, AVCaptureMetadataOutputObjectsDelegate, BarcodeScannerManagerProtocol {

    private let scannedCodeSubject = PassthroughSubject<String, Never>()
    private let captureSession = AVCaptureSession()
    private var captureOutput = AVCaptureMetadataOutput()
    private let objectTypes: [AVMetadataObject.ObjectType] = [
        .qr,
        .ean8,
        .ean13,
        .pdf417,
        .code128,
        .code39
    ]

    var scannedCode: AnyPublisher<String, Never> {
        scannedCodeSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        setupCaptureSession()
    }

    private func setupCaptureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else { return }

        captureSession.beginConfiguration()
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        if captureSession.canAddOutput(captureOutput) {
            captureSession.addOutput(captureOutput)
            captureOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureOutput.metadataObjectTypes = objectTypes
        }

        captureSession.commitConfiguration()
    }

    func startScanning() {
        guard !captureSession.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func stopScanning() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    func getSession() -> AVCaptureSession {
        return captureSession
    }

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = metadataObject.stringValue else { return }

        // Stop scanning once a code is detected
        DispatchQueue.main.async { [weak self] in
            //self?.scannedCode = code
            self?.scannedCodeSubject.send(code)
            self?.stopScanning()
        }
    }

}
