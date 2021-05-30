//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by mk.pwnz on 25.05.2021.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .wenvironmentObject(vm)
        }
    }
}
