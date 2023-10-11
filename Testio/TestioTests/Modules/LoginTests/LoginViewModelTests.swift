//
//  LoginViewModelTests.swift
//  TestioTests
//
//  Created by Krystsina on 2023-10-11.
//

import XCTest
@testable import Testio

final class LoginViewModelTests: XCTestCase {
    
    private var sut: LoginViewModel!
    private var keychainManagerMock: KeychainManagerMock!
    private var networkManagerMock: NetworkManagerMock!
    
    override func setUpWithError() throws {
        super.setUp()
        keychainManagerMock = KeychainManagerMock.shared
        networkManagerMock = NetworkManagerMock.shared
        sut = LoginViewModel(networkManager: networkManagerMock, keychainManager: keychainManagerMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        keychainManagerMock = nil
        networkManagerMock = nil
        super.tearDown()
    }
    
    func test_login_isCalledLogin() {
        // When
        sut.login()
        // Then
        XCTAssert(networkManagerMock.isCalledLoginUser, "login() was not called")
    }
    
    func test_login_success() {
        // Given
        networkManagerMock.loginResult = TestData.successLoginResult
        // When
        sut.login()
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssert(self.keychainManagerMock.isCalledSetToken, "setToken() was not called")
            XCTAssert(self.keychainManagerMock.isCalledSetUser, "setUser() was not called")
            XCTAssert(self.sut.isLoginSuccess, "isLoginSuccess was not stated to true")
            XCTAssertFalse(self.sut.isShowErrorAlert, "isShowErrorAlert was not stated to false")
        }
    }
    
    func test_login_failure() {
        // Given
        networkManagerMock.loginResult = TestData.errorLoginResult
        // When
        sut.login()
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssert(self.sut.isShowErrorAlert, "isShowErrorAlert was not stated to true")
        }
    }
}

extension LoginViewModelTests {
    enum TestData {
        static let successLoginResult: Result<LoginInfo, NetworkError> = .success(LoginInfo(token: "sampleToken"))
        static let errorLoginResult: Result<LoginInfo, NetworkError> = .failure(NetworkError.unauthorized)
    }
}
