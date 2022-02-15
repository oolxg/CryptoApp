//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by mk.pwnz on 25.05.2021.
//

import SwiftUI

@main
struct CryptoApp: App {
    init() {
        #if DEBUG
        var injectionBundlePath = "/Applications/InjectionIII.app/Contents/Resources"
        #if targetEnvironment(macCatalyst)
        injectionBundlePath = "\(injectionBundlePath)/macOSInjection.bundle"
        #elseif os(iOS)
        injectionBundlePath = "\(injectionBundlePath)/iOSInjection.bundle"
        #endif
        // if can't build project, comment next line, rebuild project and uncomment
        Bundle(path: injectionBundlePath)?.load()
        #endif

        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
