//
//  CameraPermissionManager.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation
import AVFoundation

protocol CameraPermissionManagerProtocol {
    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus
    func requestAccess(for mediaType: AVMediaType) async -> Bool
}

struct SystemCameraPermissionManager: CameraPermissionManagerProtocol {
    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: mediaType)
    }
    
    func requestAccess(for mediaType: AVMediaType) async -> Bool {
        await AVCaptureDevice.requestAccess(for: mediaType)
    }
}

final class CameraPermissionManager: ObservableObject {
    enum AuthorizationStatus {
        case authorized
        case denied
        case notDetermined
    }
    @Published var permissionStatus: AuthorizationStatus = .notDetermined
    
    private let authorizationProvider: CameraPermissionManagerProtocol
    
    init(authorizationProvider: CameraPermissionManagerProtocol = SystemCameraPermissionManager()) {
        self.authorizationProvider = authorizationProvider
    }

    func requestCameraPermission() {
        let status = authorizationProvider.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            permissionStatus = .authorized
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                self.permissionStatus = granted ? .authorized : .denied
            }
        case .denied, .restricted:
            permissionStatus = .denied
        @unknown default:
            permissionStatus = .denied
        }
    }
}
