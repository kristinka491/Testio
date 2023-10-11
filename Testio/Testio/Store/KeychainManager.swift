//
//  KeychainManager.swift
//  Testio
//
//  Created by Krystsina on 2023-10-11.
//

import Foundation
import KeychainAccess

protocol KeychainProtocol {
    func setToken(token: String)
    func token() -> String?
    func setUser(user: User)
    func user() -> User?
    func clean()
}

final class KeychainManager: KeychainProtocol {
    private enum Keys {
        static let token = "token"
        static let user = "user"
    }

    static var shared = KeychainManager()
    private let keychain = Keychain(service: "testio")

    private init() {}

    func setToken(token: String) {
        do {
            try keychain.set(token, key: Keys.token)
        } catch let error {
            print("error: \(error)")
        }
    }
    
    func token() -> String? {
        try? keychain.get(Keys.token)
    }
    
    func setUser(user: User) {
        do {
            let data = try JSONEncoder().encode(user)
            try keychain.set(data, key: Keys.user)
        } catch let error {
            print("error: \(error)")
        }
    }

    func user() -> User? {
        guard let data = try? keychain.getData(Keys.user) else {
            return nil
        }
        return try? JSONDecoder().decode(User.self, from: data)
    }

    func clean() {
        do {
            try keychain.removeAll()
        } catch let error {
            print("error: \(error)")
        }
    }
}
