//
//  NetworkManager.swift
//  ScanTeg
//
//  Created by Jithin Balan on 9/2/2026.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(
        baseURL: String?,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?
    ) async throws -> T
}

extension NetworkManagerProtocol {
    func request<T: Decodable>(
        baseURL: String? = nil,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> T {
        return try await request(baseURL: baseURL, method: method, headers: headers, body: body)
    }
}

// MARK: - Network Manager Implementation
final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Properties
    private var commonHeaders: [String: String] {
        [
            "content-type": "application/json",
            "x-api-key": "TEq5Mddna23xSNsoDeYt8aP02BJHrvoa6X07nEuD",
            "accept-language": "en",
            "authorization": "Basic Yhd9X=38D88!"
        ]
    }
    private let session: URLSession
    private let decoder: JSONDecoder

    private static var defaultSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 300
        return URLSession(configuration: configuration)
    }()
    
    // MARK: - Initialization
    init(session: URLSession? = nil,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session ?? Self.defaultSession
        self.decoder = decoder
    }
    
    // MARK: - Public Methods

    func request<T: Decodable>(baseURL: String?,
                               method: HTTPMethod,
                               headers: [String: String]?,
                               body: Data?) async throws -> T {
        
        let configuration = RequestConfiguration(
            baseURL: baseURL,
            method: method,
            headers: headers,
            body: body
        )

        let request = try createURLRequest(from: configuration)
        do {
            let (data, response) = try await session.data(for: request)
            return try self.manageResponse(data: data, response: response, decoder: decoder)
        } catch {
            throw error
        }
        
    }
    
    // MARK: - Private Methods

    private func manageResponse<T: Decodable>(data: Data, response: URLResponse, decoder: JSONDecoder) throws -> T {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError(
                errorCode: "ERROR-0",
                message: "Invalid HTTP response"
            )
        }
        switch response.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw NetworkError(
                    errorCode: "ERROR-0",
                    message: "Error decoding data"
                )
            }
        default:
            guard let decodedError = try? decoder.decode(NetworkError.self, from: data) else {
                throw NetworkError(
                    statusCode: response.statusCode,
                    errorCode: "ERROR-0",
                    message: "Unknown backend error"
                )
            }
            throw NetworkError(
                statusCode: response.statusCode,
                errorCode: decodedError.errorCode,
                message: decodedError.message
            )
        }
    }

    private func createURLRequest(from configuration: RequestConfiguration) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = configuration.scheme
        urlComponents.host =  configuration.hostURL
        
        // Create full URL
        if let path = configuration.baseURL {
            urlComponents.path = path
        }

        guard let url = urlComponents.url else {
            throw NetworkError(errorCode: "ERROR-0", message: "URL error")
        }

        var request = URLRequest(url: url)
        request.httpMethod = configuration.method.rawValue
        request.httpBody = configuration.body
        
        // Merge headers: common headers first, then config headers (config headers override common ones)
        var allHeaders = commonHeaders
        if let configHeaders = configuration.headers {
            allHeaders.merge(configHeaders) { _, new in new }
        }
        
        // Set headers
        for (key, value) in allHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}

