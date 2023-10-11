//
//  HomeViewModelTests.swift
//  TestioTests
//
//  Created by Krystsina on 2023-10-11.
//

import XCTest
@testable import Testio

final class HomeViewModelTests: XCTestCase {
    
    private var sut: HomeViewModel!
    private var keychainManagerMock: KeychainManagerMock!
    private var networkManagerMock: NetworkManagerMock!
    
    override func setUpWithError() throws {
        super.setUp()
        keychainManagerMock = KeychainManagerMock.shared
        networkManagerMock = NetworkManagerMock.shared
        sut = HomeViewModel(networkManager: networkManagerMock, keychainManager: keychainManagerMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        keychainManagerMock = nil
        networkManagerMock = nil
        super.tearDown()
    }
    
    func test_loadData_isCalledLoadData() {
        // When
        sut.loadData()
        // Then
        XCTAssert(networkManagerMock.isCalledLoadData, "loadData() was not called")
        XCTAssert(sut.isLoading, "isLoading was not stated to true")
    }
    
    func test_loadData_success() {
        // Given
        networkManagerMock.loadDataResult = TestData.successListOfLocations
        let sortedTestArray = TestData.testArray.sorted(by: { $0.name < $1.name })
        // When
        sut.loadData()
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.sut.isLoading, "isLoading was not changed")
            XCTAssertEqual(self.sut.listOfLocations, sortedTestArray, "Array was not sorted")
        }
    }
    
    func test_loadData_failureWithRefreshToken() {
        // Given
        networkManagerMock.loadDataResult = TestData.errorLoginResult
        // When
        sut.loadData(isGotNewToken: true)
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.sut.isLoading, "isLoading was not changed")
            XCTAssert(self.sut.isUserLogout, "isUserLogout was not stated to true")
        }
    }
    
    func test_loadData_failureWithNoRefreshToken() {
        // Given
        networkManagerMock.loadDataResult = TestData.errorLoginResult
        // When
        sut.loadData()
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.sut.isLoading, "isLoading was not changed")
            XCTAssertFalse(self.sut.isUserLogout, "isUserLogout was not stated to false")
        }
    }
    
    func test_filterData_isSortedDataByDistance() {
        // Given
        sut.listOfLocations = TestData.testArray
        sut.selectedFilterType = .byDistance
        let sortedTestArray = TestData.testArray.sorted(by: { $0.distance < $1.distance })
        // When
        sut.filterData()
        // Then
        XCTAssertEqual(sut.listOfLocations, sortedTestArray, "Array was not sorted by distance")
    }
    
    func test_filterData_isSortedDataAlphabetically() {
        // Given
        sut.listOfLocations = TestData.testArray
        sut.selectedFilterType = .alphabetically
        let sortedTestArray = TestData.testArray.sorted(by: { $0.name < $1.name })
        // When
        sut.filterData()
        // Then
        XCTAssertEqual(sut.listOfLocations, sortedTestArray, "Array was not sorted alphabetically")
    }
    
    func test_logout_isCalledLogout() {
        // When
        sut.logout()
        // Then
        XCTAssert(keychainManagerMock.isCalledClean, "logout() was not called")
    }
    
    func test_logout_isLoginInfoCleaned() {
        // Given
        keychainManagerMock.setToken(token: TestData.testToken)
        keychainManagerMock.setUser(user: TestData.testUser)
        // When
        sut.logout()
        // Then
        XCTAssertNil(keychainManagerMock.user(), "user was not cleaned")
        XCTAssertNil(keychainManagerMock.token(), "token was not cleaned")
    }
}

extension HomeViewModelTests {
    enum TestData {
        static let successListOfLocations: Result<[Location], NetworkError> = .success([])
        static let errorLoginResult: Result<[Location], NetworkError> = .failure(NetworkError.unauthorized)
        static let testArray: [Location] = [
            Location(
                name: "Vilnius",
                distance: 250),
            Location(
                name: "Kaunas",
                distance: 200),
            Location(
                name: "Klaipeda",
                distance: 300)
        ]
        static let testToken: String = "SampleToken"
        static let testUser: User = User(username: "SampleUsername", password: "SamplePassword")
    }
}
