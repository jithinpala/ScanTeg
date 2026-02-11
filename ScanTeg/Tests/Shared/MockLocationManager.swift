//
//  MockLo.swift
//  ScanTeg
//
//  Created by Jithin Balan on 11/2/2026.
//

import Combine
import CoreLocation
import Foundation

@testable import ScanTeg

final class MockLocationManager: NSObject, LocationManagerProtocol {
    var isDeviceLocationServiceEnabled: Bool {
        return true
    }

    private let authorizationStatusSubject: CurrentValueSubject<CLAuthorizationStatus, Never>
    var checkLocationAuthorizationCalled = false
    var didStartUpdatingLocation = false
    var location: CLLocationCoordinate2D?

    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }
    
    override init() {
        authorizationStatusSubject = CurrentValueSubject(.notDetermined)
        super.init()
    }

    // Helper method for tests to simulate status changes
    func simulateAuthorizationStatusChange(_ status: CLAuthorizationStatus) {
        //authorizationStatus = status
        authorizationStatusSubject.send(status)
    }
    
    // Helper method for tests to simulate location updates
    func simulateLocationUpdate(_ coordinate: CLLocationCoordinate2D) {
        location = coordinate
    }

    func requestWhenInUseAuthorization() {
        checkLocationAuthorizationCalled = true
    }
}
