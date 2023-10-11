//
//  TestioApp.swift
//  Testio
//
//  Created by Krystsina on 2023-10-10.
//

import SwiftUI

@main
struct TestioApp: App {
    @StateObject private var testioViewModel = TestioViewModel()
    
    var body: some Scene {
        WindowGroup {
            if testioViewModel.isUserLoggedIn {
                HomeView()
                    .environmentObject(testioViewModel)
            } else {
                LoginView()
                    .environmentObject(testioViewModel)
            }
        }
    }
}
