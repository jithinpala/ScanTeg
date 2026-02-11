//
//  DashBoardViewModel.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Combine
import Foundation
import CoreLocation

class DashBoardViewModel: ObservableObject {
    enum DashboardState {
        case idle
        case loading
        case locationAuthorized
        case locationDenied
        case venueLoaded(_ response: DashboardResponse)
        case failed
    }

    let manager: DashBoardServiceProtocol
    private let locationManager: any LocationManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var state: DashboardState = DashboardState.idle

    var currentLocation: CLLocationCoordinate2D? {
        locationManager.location
    }
    
    init(
        manager: DashBoardServiceProtocol = DashBoardService(),
        locationManager: any LocationManagerProtocol = LocationManager()
    ) {
        self.manager = manager
        self.locationManager = locationManager
        setupBinding()
    }
    
    private func setupBinding() {
        // Subscribe to authorization status changes
        locationManager.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.updateState(for: status)
            }
            .store(in: &cancellables)
    }
    
    private func updateState(for status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            state = .idle
        case .denied, .restricted:
            state = .locationDenied
        case .authorizedAlways, .authorizedWhenInUse:
            state = .locationAuthorized
        @unknown default:
            state = .locationDenied
        }
    }

    @MainActor
    func getData() async {
        state = .loading
        do {
            let latitude = currentLocation?.latitude ?? 0.0
            let longitude = currentLocation?.longitude ?? 0.0
            let results = try await manager.fetchDashboardData(latitude: latitude, longitude: longitude)
            state = .venueLoaded(results)
        } catch {
            state = .failed
        }
    }
}

