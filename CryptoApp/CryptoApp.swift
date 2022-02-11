//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by mk.pwnz on 25.05.2021.
//

import SwiftUI

@main
struct CryptoApp: App {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var hudState = HUDState.shared
    @StateObject private var loginVM = LoginViewModel()
    @Environment(\.scenePhase) private var scenePhase

    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if loginVM.shouldShowLaunchView {
                    LaunchView()
                        .environmentObject(loginVM)
                } else if loginVM.shouldShowLoginView {
                    LoginScreen()
                        .environmentObject(loginVM)
                } else {
                    NavigationView {
                        HomeView()
                            .navigationBarHidden(true)
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .environmentObject(homeVM)
                }
             }
            .hud(isPresented: $hudState.isPresented, text: hudState.text, iconName: hudState.iconName, hideAfter: hudState.duration, backgroundColor: hudState.backgroundColor)
            .onChange(of: scenePhase, perform: loginVM.handleNewScenePhase)
        }
    }
}
