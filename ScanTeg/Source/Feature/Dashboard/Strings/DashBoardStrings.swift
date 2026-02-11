//
//  DashBoardStrings.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

enum DashBoardStrings {
    static let dashboardTitle = NSLocalizedString(
        "dash-board-strings.dashboardTitle",
        tableName: "ScanTeg",
        value: "Venue List",
        comment: "Dash board title"
    )
    static let locationPermissionDenied = NSLocalizedString(
        "dash-board-strings.locationPermissionDenied",
        tableName: "ScanTeg",
        value: "Location permission denied. Please enable location services in settings.",
        comment: "Location permission denied."
    )
    static let locationAuthorized = NSLocalizedString(
        "dash-board-strings.locationAuthorized",
        tableName: "ScanTeg",
        value: "We got the location",
        comment: "Location Authorized."
    )
    static let somethingWentWrong = NSLocalizedString(
        "dash-board-strings.somethingWentWrong",
        tableName: "ScanTeg",
        value: "Something went wrong.",
        comment: "Something went wrong."
    )
    static let pleaseTryAgain = NSLocalizedString(
        "dash-board-strings.pleaseTryAgain",
        tableName: "ScanTeg",
        value: "Please try again.",
        comment: "Please try again."
    )
    static let retryButtonTitle = NSLocalizedString(
        "dash-board-strings.retryButtonTitle",
        tableName: "ScanTeg",
        value: "Retry",
        comment: "Retry button title"
    )
    static let welcomeTitle = NSLocalizedString(
        "dash-board-strings.welcomeTitle",
        tableName: "ScanTeg",
        value: "Welcome to ScanTeg",
        comment: "Welcome message"
    )
    static let scanBarcodeMessage = NSLocalizedString(
        "dash-board-strings.scanBarcodeMessage",
        tableName: "ScanTeg",
        value: "Please place the barcode inside the frame",
        comment: "Scan barcode message"
    )
    static let validationMessageTitle = NSLocalizedString(
        "dash-board-strings.validationMessageTitle",
        tableName: "ScanTeg",
        value: "Validation completed",
        comment: "Validation complete message"
    )
    static let ticketStatusTitle = NSLocalizedString(
        "dash-board-strings.ticketStatusTitle",
        tableName: "ScanTeg",
        value: "Ticket status is: %@",
        comment: "Valid ticket status message"
    )
    static let cameraAccessTitle = NSLocalizedString(
        "dash-board-strings.cameraAccessTitle",
        tableName: "ScanTeg",
        value: "Please allow camera access",
        comment: "Access title message"
    )
    static let cameraAccessDeniedTitle = NSLocalizedString(
        "dash-board-strings.cameraAccessDeniedTitle",
        tableName: "ScanTeg",
        value: "Camera Access Required",
        comment: "Access denied title message"
    )
    static let openSettingForLocationTitle = NSLocalizedString(
        "dash-board-strings.openSettingForLocationTitle",
        tableName: "ScanTeg",
        value: "Please enable location access in Settings",
        comment: "Enable location access in Settings title"
    )
    static let openSettingTitle = NSLocalizedString(
        "dash-board-strings.openSettingTitle",
        tableName: "ScanTeg",
        value: "Please enable camera access in Settings",
        comment: "Enable camera access in Settings title"
    )
    static let settingButtonTitle = NSLocalizedString(
        "dash-board-strings.settingButtonTitle",
        tableName: "ScanTeg",
        value: "Open Settings",
        comment: "Settings button title"
    )
}
