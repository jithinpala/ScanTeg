//
//  DashBoardViewModel.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Foundation
import CoreLocation
import Combine

class DashBoardViewModel: ObservableObject {
    let eventTileTitle = "View events"
    let scanTileTitle = "Scan Barcode"
    
    let manager: DashBoardServiceProtocol
    
    enum DashboardState {
        case idle
        case loading
        case locationAuthorized
        case locationDenied
        case venueLoaded(_ response: DashboardResponse)
        case failed
    }
        

    @Published var locationManager = LocationManager()
    @Published var state: DashboardState = DashboardState.idle
    
    private var cancellables = Set<AnyCancellable>()

    var currentLocation: CLLocationCoordinate2D? {
        locationManager.location
    }
    
    var isLocationPermissionGranted: Bool {
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        default: return false
        }
    }
    
    init(manager: DashBoardServiceProtocol = DashBoardService()) {
        self.manager = manager
        setupBinding()
    }
    
    private func setupBinding() {
        // Observe authorization status changes
        locationManager.$authorizationStatus
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

    func getLocationAuthorization() {
        guard !isLocationPermissionGranted else { return }
        locationManager.checkLocationAuthorization()
    }

    @MainActor
    func getData() async {
        state = .loading
        do {
            let latitude = currentLocation?.latitude ?? 0.0
            let longitude = currentLocation?.longitude ?? 0.0
            
            let results = try await manager.fetchDashboardData(latitude: latitude, longitude: longitude)
            print("Fetched dashboard data: \(results)")
            state = .venueLoaded(results)
        } catch {
            print("Error fetching dashboard data: \(error)")
            state = .failed
        }
    }
}

