//
//  NetworkError.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Foundation

struct NetworkError: Error {
    var statusCode: Int!
    let errorCode: String
    var message: String

    init(statusCode: Int = 0, errorCode: String, message: String) {
        self.statusCode = statusCode
        self.errorCode = errorCode
        self.message = message
    }

    var errorCodeNumber: String {
        errorCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    private enum CodingKeys: String, CodingKey {
        case errorCode
        case message
    }
}

extension NetworkError: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode = try container.decode(String.self, forKey: .errorCode)
        message = try container.decode(String.self, forKey: .message)
    }
}
