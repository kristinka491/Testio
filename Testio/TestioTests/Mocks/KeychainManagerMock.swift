//
//  KeychainManagerMock.swift
//  TestioTests
//
//  Created by Krystsina on 2023-10-11.
//

import XCTest
@testable import Testio

final class KeychainManagerMock: KeychainProtocol {
    private var tokenValue: String?
    private var userValue: User?
    
    static let shared = KeychainManagerMock()
    private init() {}
    
    private(set) var isCalledSetToken = false
    func setToken(token: String) {
        isCalledSetToken = true
        tokenValue = token
    }
    
    private(set) var isCalledToken = false
    func token() -> String? {
        isCalledToken = true
        return tokenValue
    }
    
    private(set) var isCalledSetUser = false
    func setUser(user: Testio.User) {
        isCalledSetUser = true
        userValue = user
    }
    
    private(set) var isCalledUser = false
    func user() -> Testio.User? {
        isCalledUser = true
        return userValue
    }
    
    private(set) var isCalledClean = false
    func clean() {
        isCalledClean = true
        tokenValue = nil
        userValue = nil
    }
}
