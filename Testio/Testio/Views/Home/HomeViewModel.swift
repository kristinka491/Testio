//
//  HomeViewModel.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    enum FilterType: String, CaseIterable {
        case byDistance
        case alphabetically
        
        var title: String {
            switch self {
            case .byDistance:
               return StringConstants.byDistanceTitle
            case .alphabetically:
                return StringConstants.alphabeticalTitle
            }
        }
        
        func sortData(data: [Location]) -> [Location] {
            switch self {
            case .alphabetically:
                return data.sorted(by: { $0.name < $1.name })
            case .byDistance:
                return data.sorted(by: { $0.distance < $1.distance })
            }
        }
    }
    
    @Published var selectedFilterType: HomeViewModel.FilterType = .alphabetically
    @Published var listOfLocations = [Location]()
    @Published var isLoading: Bool = true
    @Published var isUserLogout = false
    
    private let networkManager: NetworkProtocol
    private let keychainManager: KeychainProtocol
    
    init(
        networkManager: NetworkProtocol = NetworkManager.shared,
        keychainManager: KeychainProtocol = KeychainManager.shared
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
    
    func loadData(isGotNewToken: Bool = false) {
        isLoading = true

        networkManager.loadData() { result in
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let array):
                    self.listOfLocations = self.selectedFilterType.sortData(data: array)
                case .failure(let error):
                    switch error {
                    case .unauthorized:
                        if !isGotNewToken {
                            self.refreshTokenIfPossible()
                        } else {
                            self.isUserLogout = true
                        }
                        print("error: \(error)")
                    default:
                        print("error: \(error)")
                    }
                }
            }
        }
    }
    
    func filterData() {
        listOfLocations = selectedFilterType.sortData(data: listOfLocations)
    }
    
    func logout() {
        keychainManager.clean()
    }
    
    private func refreshTokenIfPossible() {
        guard let user = keychainManager.user() else {
            return
        }
        isLoading = true
        
        networkManager.loginUser(
            username: user.username,
            password: user.password) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    switch result {
                    case .success(let loginInfo):
                        self.keychainManager.setToken(token: loginInfo.token)
                        self.loadData(isGotNewToken: true)
                    case .failure(let error):
                        self.isUserLogout = true
                        print("error: \(error)")
                    }
                }
            }
    }
}
