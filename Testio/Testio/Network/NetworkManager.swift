//
//  NetworkManager.swift
//  Testio
//
//  Created by Krystsina on 2023-10-11.
//

import Foundation

protocol NetworkProtocol {
    func loginUser(
        username: String,
        password: String,
        completion: @escaping (Result<LoginInfo, NetworkError>) -> Void
    )
    func loadData(completion: @escaping (Result<[Location], NetworkError>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case unauthorized
    case serverError(Int)
    case noData
    case invalidRequestBody
    case decodingError(Error)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

final class NetworkManager: NetworkProtocol {
    private var baseURL = "https://playground.nordsec.com/v1/"
    
    private enum UrlPath {
        static let tokens = "tokens"
        static let servers = "servers"
    }

    static var shared = NetworkManager()

    private init() {}
    
    func loginUser(
        username: String,
        password: String,
        completion: @escaping (Result<LoginInfo, NetworkError>) -> Void
    ) {
        let body: [String: String] = [
            "username": username,
            "password": password
        ]
        
        performRequest(
            path: UrlPath.tokens,
            method: HTTPMethod.post,
            body: body,
            completion: completion
        )
    }
    
    func loadData(completion: @escaping (Result<[Location], NetworkError>) -> Void) {
        performRequest(
            path: UrlPath.servers,
            method: HTTPMethod.get,
            requiredToken: true,
            completion: completion
        )
    }
    
    private func performRequest<T: Decodable>(
        path: String,
        method: HTTPMethod,
        body: [String: Any]? = nil,
        requiredToken: Bool = false,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue

        if requiredToken,
            let token = KeychainManager.shared.token() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
            } catch {
                completion(.failure(.invalidRequestBody))
                return
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            if httpResponse.statusCode == 401 {
                completion(.failure(.unauthorized))
                return
            }

            if !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(.serverError(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(responseObject))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}

