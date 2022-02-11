//
//  SettingsView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09/02/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SettingsViewModel()
    @State private var showAppInfoView: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.theme.background
                    .ignoresSafeArea()
                
                List {
                    Section {
                        NavigationLink(destination: {
                            PrivacySettingsView()
                                .environmentObject(vm)
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
                        Button("About") {
                            showAppInfoView.toggle()
                        }
                    }
                    .sheet(isPresented: $showAppInfoView) {
                        AppInfoView()
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
