//
//  RequestConfiguration.swift
//  ScanTeg
//
//  Created by Jithin Balan on 10/2/2026.
//

import Foundation

struct RequestConfiguration {
    let baseURL: String?
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?

    var hostURL: String {
        return "ignition.qa.ticketek.net"
    }

    var scheme: String {
        return "https"
    }
    
    init(baseURL: String? = nil,
         method: HTTPMethod = .get,
         headers: [String: String]? = nil,
         body: Data? = nil) {
        self.baseURL = baseURL
        self.method = method
        self.headers = headers
        self.body = body
    }
}
