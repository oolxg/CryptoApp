//
//  SettingsView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09/02/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var hudState: HUDState
    @StateObject private var vm = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    Section {
                        NavigationLink(destination: {
                            PrivacySettingsView()
                        }) {
                            Label("Privacy and security", systemImage: "hand.raised.fill")
                                .labelStyle(ColorfulIconLabelStyle(color: .blue))
                        }

                        NavigationLink(destination: {
                            Text("To be completed")

                        }) {
                            Label("Appearance", systemImage: "paintbrush.pointed.fill")
                                .labelStyle(ColorfulIconLabelStyle(color: .theme.green))
                        }

                    }
                    
                    Section {
                        NavigationLink("About") {
                            AppInfoView()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton {
                        self.dismiss()
                    }
                    .font(.headline)
                }
            }
            .foregroundColor(.theme.accent)

        }
    }
}
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
