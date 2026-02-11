//
//  LocationManager.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Combine
import CoreLocation

protocol LocationManagerProtocol {
    var location:  CLLocationCoordinate2D? { get }
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }
    var isDeviceLocationServiceEnabled: Bool { get }

    func requestWhenInUseAuthorization()
}

final class LocationManager: NSObject, LocationManagerProtocol, CLLocationManagerDelegate {
    var location: CLLocationCoordinate2D?
    private let manager: CLLocationManager
    private let authorizationStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()

    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }

    var isDeviceLocationServiceEnabled: Bool {
        let status = manager.authorizationStatus
        return status != .notDetermined &&
        status != .denied &&
        status != .restricted
    }

    override init() {
        manager = CLLocationManager()
        super.init()
        manager.delegate = self
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatusSubject.send(manager.authorizationStatus)
        guard !isDeviceLocationServiceEnabled else { return }
        requestWhenInUseAuthorization()
    }
}
