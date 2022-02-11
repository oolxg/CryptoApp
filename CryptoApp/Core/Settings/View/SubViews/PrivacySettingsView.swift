//
//  PrivacySettingsView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09/02/2022.
//

import SwiftUI
import Combine

struct PrivacySettingsView: View {
    @EnvironmentObject private var vm: SettingsViewModel
    @State private var showAutoLockTimeMenu: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            List {
                Section {
                    Toggle("Use password to unblock the app", isOn: vm.$isPasswordSecurityActive)
                        .onChange(of: vm.isPasswordSecurityActive) { newPasswordSecurityUsingStatus in
                            // if user disables password login, we should also disable using of biometry login
                            if newPasswordSecurityUsingStatus == false {
                                vm.useBiometryToUnlock = false
                            }
                        }
                }
                
                faceIDSection

                passwordSettingsSection
            }
        }
        .foregroundColor(.theme.accent)
        .navigationTitle("Privacy and security")
        .confirmationDialog("Set auto-lock time", isPresented: $showAutoLockTimeMenu) {
            autoLockTimeDialogMenu
        }
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
            .preferredColorScheme(.dark)
    }
}


extension PrivacySettingsView {
    @ViewBuilder private var faceIDSection: some View {
        if vm.isPasswordSecurityActive {
            Section {
                HStack {
                    Label("Use Face ID", systemImage: "faceid")
                        .labelStyle(ColorfulIconLabelStyle(color: .theme.green))
                    
                    Spacer()
                    
                    Toggle("", isOn: vm.$useBiometryToUnlock)
                }
            }
        }
    }
    
    @ViewBuilder private var passwordSettingsSection: some View {
        if vm.isPasswordSecurityActive {
            NavigationLink("Change password", isActive: $vm.showPasswordInputView) {
                PasswordTextFieldView()
                    .environmentObject(vm)
            }
            
            HStack {
                Text("Auto-lock")
                
                Spacer ()
                
                Text("If away for \(vm.appAutoLockTimeSeconds / 60) min")
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.theme.secondaryText)
            }
            .onTapGesture {
                showAutoLockTimeMenu.toggle()
            }
        }
    }
    
    @ViewBuilder private var autoLockTimeDialogMenu: some View {
        Button("if away for 1 minute") {
            vm.appAutoLockTimeSeconds = 60
        }
        
        Button("if away for 5 minute") {
            vm.appAutoLockTimeSeconds = 5 * 60
        }
        
        Button("if away for 10 minutes") {
            vm.appAutoLockTimeSeconds = 10 * 60
        }
    }
}

// The only purpose of this view is one bug with FocusState
// It doesn't work within main view, so i made one view extra...
fileprivate struct PasswordTextFieldView: View {
    @FocusState private var isPasswordTextFieldFocused: Bool
    @EnvironmentObject private var vm: SettingsViewModel
    
    var body: some View {
        ZStack {
            TextField("Enter your username", text: $vm.passwordText)
                .focused($isPasswordTextFieldFocused)
                .keyboardType(.numberPad)
                .onReceive(Just($vm.passwordText)) { newValue in
                    let filtered = newValue.wrappedValue.filter { "0123456789".contains($0) }
                    if filtered != newValue.wrappedValue {
                        vm.passwordText = filtered
                    }

                }
            
            Color.theme.background.ignoresSafeArea()
            
            Text(vm.passwordText)
                .foregroundColor(.white)
        }
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isPasswordTextFieldFocused = true
            }
        }
    }
}
