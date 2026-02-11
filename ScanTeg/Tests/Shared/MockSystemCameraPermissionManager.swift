//
//  MockSystemCameraPermissionManager.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 11/2/2026.
//

import Foundation
import AVFoundation
@testable import ScanTeg

final class MockSystemCameraPermissionManager: CameraPermissionManagerProtocol {
    var mockStatus: AVAuthorizationStatus = .notDetermined
    var mockGrantAccess = true

    func authorizationStatus(for mediaType: AVMediaType) -> AVAuthorizationStatus {
        mockStatus
    }
    
    func requestAccess(for mediaType: AVMediaType) async -> Bool {
        mockGrantAccess
    }
}
