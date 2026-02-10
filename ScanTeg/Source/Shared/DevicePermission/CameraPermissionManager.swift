//
//  CameraPermissionManager.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation
import AVFoundation

final class CameraPermissionManager: ObservableObject {
    enum AuthorizationStatus {
        case authorized
        case denied
        case notDetermined
    }
    @Published var permissionStatus: AuthorizationStatus = .notDetermined

    func requestCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthorizationStatus {
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
