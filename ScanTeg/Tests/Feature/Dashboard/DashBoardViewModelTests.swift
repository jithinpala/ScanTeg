//
//  DashBoardViewModelTests.swift
//  ScanTegTests
//
//  Created by Jithin Balan on 10/2/2026.
//

import Testing
import CoreLocation
import Combine
@testable import ScanTeg

@Suite("Dashboard View model tests")
struct DashboardViewModelTests {
    
    @Test
    func initialStateShouldBeIdle() {
        let viewModel = makeViewModel()

        guard case .idle = viewModel.state else {
            Issue.record("Expected initial state to be idle")
            return
        }
    }

    @Test
    func locationDeniedShouldUpdateStateToLocationDenied() async {
        let mockLocationManager = MockLocationManager()
        let viewModel = makeViewModel(locationManager: mockLocationManager)
        
        // When
        mockLocationManager.simulateAuthorizationStatusChange(.denied)
        
        // Wait for async update to complete on main queue
        await MainActor.run {
            // Give the main queue a chance to process
        }
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

        guard case .locationDenied = viewModel.state else {
            Issue.record("Expected state to be locationDenied")
            return
        }
    }

    @Test
    func locationRestrictedShouldUpdateStateToLocationDenied() async {
        let mockLocationManager = MockLocationManager()
        let viewModel = makeViewModel(locationManager: mockLocationManager)
        mockLocationManager.simulateAuthorizationStatusChange(.restricted)

        // Wait for async update to complete on main queue
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        guard case .locationDenied = viewModel.state else {
            Issue.record("Expected state to be locationDenied")
            return
        }
    }

    @Test
    func locationAuthorizedWhenInUseShouldUpdateStateToLocationAuthorized() async {
        let mockLocationManager = MockLocationManager()
        let viewModel = makeViewModel(locationManager: mockLocationManager)
        mockLocationManager.simulateAuthorizationStatusChange(.authorizedWhenInUse)

        // Wait for async update to complete on main queue
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        guard case .locationAuthorized = viewModel.state else {
            Issue.record("Expected state to be locationAuthorized")
            return
        }
    }

    @Test
    func notDeterminedShouldUpdateStateToIdle() async {
        let mockLocationManager = MockLocationManager()
        let viewModel = makeViewModel(locationManager: mockLocationManager)
        mockLocationManager.simulateAuthorizationStatusChange(.notDetermined)
        
        // Wait for async update to complete on main queue
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        guard case .idle = viewModel.state else {
            Issue.record("Expected state to be idle")
            return
        }
    }

    @Test
    func currentLocationWhenLocationIsSetShouldReturnLocation() {
        let mockLocationManager = MockLocationManager()
        let expectedCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        mockLocationManager.simulateLocationUpdate(expectedCoordinate)
        let viewModel = makeViewModel(locationManager: mockLocationManager)
        
        #expect(viewModel.currentLocation?.latitude == expectedCoordinate.latitude)
        #expect(viewModel.currentLocation?.longitude == expectedCoordinate.longitude)
    }

    @Test
    func currentLocationWhenLocationIsNilShouldReturnNil() {
        let mockLocationManager = MockLocationManager()
        mockLocationManager.location = nil
        let viewModel = makeViewModel(locationManager: mockLocationManager)
        
        #expect(viewModel.currentLocation == nil)
    }

    @Test
    func getDataForMultipleVenue() async {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockPath = "venuesList"
        let dashBoardService = DashBoardService(networkManager: mockNetworkManager)
        
        let mockLocationManager = MockLocationManager()
        mockLocationManager.location = nil
        let viewModel = makeViewModel(locationManager: mockLocationManager, service: dashBoardService)
        await viewModel.getData()
        
        guard case let .venueLoaded(result) = viewModel.state else {
            Issue.record("Expected state to be venueLoaded")
            return
        }
        #expect(result.venues?.count == 2)
        #expect(result.singleVenue == nil)
    }

    @Test
    func getDataForSingleVenue() async {
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.mockPath = "singleVenue"
        let dashBoardService = DashBoardService(networkManager: mockNetworkManager)
        
        let mockLocationManager = MockLocationManager()
        mockLocationManager.location = nil
        let viewModel = makeViewModel(locationManager: mockLocationManager, service: dashBoardService)
        await viewModel.getData()
        
        guard case let .venueLoaded(result) = viewModel.state else {
            Issue.record("Expected state to be venueLoaded with single venue")
            return
        }
        #expect(result.venues == nil)
        #expect(result.singleVenue?.name == "Adelaide Entertainment Centre")
    }

    private func makeViewModel(
        locationManager: any LocationManagerProtocol = MockLocationManager(),
        service: DashBoardServiceProtocol = MockDashBoardService()
    ) -> DashBoardViewModel {
        DashBoardViewModel(
            manager: service,
            locationManager: locationManager
        )
    }
}
