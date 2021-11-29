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
    @State private var showLaunchScreen = true
    @State private var isSuccessfullyAuthorized = false
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5..<1.8)) {
                            withAnimation(.linear(duration: 0.5)) {
                                showLaunchScreen = false
                            }
                        }
                    }
            } else if isSuccessfullyAuthorized != true {
                LoginScreen(isSuccessfullyAuthorized: $isSuccessfullyAuthorized)
            } else {
                NavigationView {
                    HomeView()
                        .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .environmentObject(vm)
            }
         }
    }
}
