//
// Created by mk.pwnz on 16/02/2022.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var hudState = HUDState.shared
    @StateObject private var loginVM = LoginViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
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

class RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }

    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController = UIHostingController(rootView: Self.previews)
    }
    #endif
}