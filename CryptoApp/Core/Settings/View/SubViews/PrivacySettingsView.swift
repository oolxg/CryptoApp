//
//  PrivacySettingsView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09/02/2022.
//

import SwiftUI

struct PrivacySettingsView: View {
    @State private var isPasswordSecurityActive: Bool = false
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            List {
                Section {
                   Toggle("Use password to unblock the app", isOn: $isPasswordSecurityActive)
                }
                
                if isPasswordSecurityActive {
                    NavigationLink("Change password") {
                        Text("To be done...")
                    }
                }
            }
        }
        .foregroundColor(.theme.accent)
        .navigationTitle("Privacy and security")
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
    }
}
