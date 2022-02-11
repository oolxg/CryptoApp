//
//  SettingsViewModel.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09/02/2022.
//

import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    @KeyChain(key: Constants.KeyChain.pincodeKey, account: Constants.KeyChain.account) var userPincode
    @AppStorage(Constants.AppSettings.Privacy.isPasswordSecurityActive) var isPasswordSecurityActive: Bool = false
    @AppStorage(Constants.AppSettings.Privacy.appAutoLockTime) var appAutoLockTimeSeconds: Int = 5 * 60
    @AppStorage(Constants.AppSettings.Privacy.useBiometryToUnlock) var useBiometryToUnlock: Bool = false
    @Published var passwordText: String = ""
    @Published var showPasswordInputView: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        addSubscriptions()
    }
    
    private func addSubscriptions() {
        $passwordText
            .filter { $0.count == 4 }
            .sink { [weak self] newPassword in
                guard let self = self else { return }
                self.userPincode = newPassword.data(using: .utf8)
                self.showPasswordInputView = false
            }
            .store(in: &cancellables)
        
        // this hack needs to clear 'passwordText' after the view is dismissed
        $showPasswordInputView
            .filter { !$0 }
            .sink { _ in
                self.passwordText = ""
            }
            .store(in: &cancellables)
    }
}
