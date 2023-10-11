//
//  NetworkManagerMock.swift
//  TestioTests
//
//  Created by Krystsina on 2023-10-11.
//

import XCTest
@testable import Testio

final class NetworkManagerMock: NetworkProtocol {
    var loginResult: Result<LoginInfo, NetworkError>?
    var loadDataResult: Result<[Location], NetworkError>?
    
    static let shared = NetworkManagerMock()
    private init() {}
    
    private(set) var isCalledLoginUser = false
    func loginUser(
        username: String,
        password: String,
        completion: @escaping (Result<LoginInfo, NetworkError>) -> Void
    ) {
        isCalledLoginUser = true
        if let loginResult = loginResult {
            completion(loginResult)
        }
    }
    
    private(set) var isCalledLoadData = false
    func loadData(completion: @escaping (Result<[Location], NetworkError>) -> Void) {
        isCalledLoadData = true
        if let loadDataResult = loadDataResult {
            completion(loadDataResult)
        }
    }
}


