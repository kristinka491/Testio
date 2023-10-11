//
//  LoginViewModel.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import Foundation

final class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoginSuccess: Bool = false
    @Published var isShowErrorAlert: Bool = false
    
    private let networkManager: NetworkProtocol
    private let keychainManager: KeychainProtocol
    
    init(
        networkManager: NetworkProtocol = NetworkManager.shared,
        keychainManager: KeychainProtocol = KeychainManager.shared
    ) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
    
    func login() {
        networkManager.loginUser(
            username: username,
            password: password
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loginInfo):
                    self.keychainManager.setToken(token: loginInfo.token)
                    self.keychainManager.setUser(user: User(
                        username: self.username,
                        password: self.password)
                    )

                    self.isLoginSuccess = true
                case .failure:
                    self.isShowErrorAlert = true
                }
            }
        }
    }
}
