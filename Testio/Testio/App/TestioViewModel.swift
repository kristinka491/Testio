//
//  TestioViewModel.swift
//  Testio
//
//  Created by Krystsina on 2023-10-11.
//

import Foundation

final class TestioViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
        
    init() {
        isUserLoggedIn = KeychainManager.shared.user() != nil
    }
}
