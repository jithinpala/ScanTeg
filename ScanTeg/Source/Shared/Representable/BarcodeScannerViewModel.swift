//
//  BarcodeScannerViewModel.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation
import AVFoundation

class BarcodeScannerViewModel: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var scannedCode: String?
    @Published var isScanning = false

    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()

    override init() {
        super.init()
        configureSession()
    }

    func getSession() -> AVCaptureSession {
        return session
    }

    private func configureSession() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            print("Failed to access camera.")
            return
        }

        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            print("Cannot add video input")
            return
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [
                .qr,
                .ean8,
                .ean13,
                .pdf417,
                .code128,
                .code39
            ]
        } else {
            print("Cannot add metadata output")
            return
        }
    }

    func startScanning() {
        guard !session.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
            DispatchQueue.main.async {
                self?.isScanning = true
            }
        }
    }

    func stopScanning() {
        guard session.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
            DispatchQueue.main.async {
                self?.isScanning = false
            }
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard !metadataObjects.isEmpty else { return }
        
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let code = metadata.stringValue {
            DispatchQueue.main.async { [weak self] in
                self?.scannedCode = code
                self?.stopScanning()
            }
        }
    }
    
    func setRectOfInterest(_ rect: CGRect) {
        metadataOutput.rectOfInterest = rect
    }
}
