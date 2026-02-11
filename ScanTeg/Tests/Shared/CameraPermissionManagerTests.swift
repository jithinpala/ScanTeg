//
//  CameraPermissionManagerTests.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 11/2/2026.
//

import Testing
@testable import ScanTeg

struct CameraPermissionManagerTests {
    @Test
    func initialStatus() {
        let cameraPermissionManager = MockSystemCameraPermissionManager()
        let manager = CameraPermissionManager(authorizationProvider: cameraPermissionManager)
        #expect(manager.permissionStatus == .notDetermined)
    }
    
    @MainActor
    @Test
    func alreadyAuthorized() {
        let cameraPermissionManager = MockSystemCameraPermissionManager()
        cameraPermissionManager.mockStatus = .authorized

        let manager = CameraPermissionManager(authorizationProvider: cameraPermissionManager)
        manager.requestCameraPermission()
        
        #expect(manager.permissionStatus == .authorized)
    }
    
    @MainActor
    @Test
    func restricted() {
        let cameraPermissionManager = MockSystemCameraPermissionManager()
        cameraPermissionManager.mockStatus = .restricted

        let manager = CameraPermissionManager(authorizationProvider: cameraPermissionManager)
        manager.requestCameraPermission()
        
        #expect(manager.permissionStatus == .denied)
    }
}
