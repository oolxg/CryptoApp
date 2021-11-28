    //
    //  LaunchViewModel.swift
    //  CryptoApp
    //
    //  Created by mk.pwnz on 28.11.2021.
    //

import Foundation
import Combine
import LocalAuthentication

class LoginViewModel: ObservableObject {
    enum AuthStatus {
        case successfullyAuthorized, unathorized, wrongPassword
    }
    
    @Published var authStatus: AuthStatus = .unathorized
    @Published private(set) var pincodeInput: [String] = []
    @Published private(set) var failedLoginWithBiometricsCount: Int = 0
    
    var isNumpadDisabled: Bool {
        pincodeInput.count == 4
    }
    private var cancellables = Set<AnyCancellable>()
    var authIconName: String {
        LAContext().biometryType == .faceID ? "faceid" : "touchid"
    }
    var isAuthWithBiometricsAvailable: Bool {
        failedLoginWithBiometricsCount < 3 
    }
    
    func makeBiometricAuth() async {
        let scanner = LAContext()
        
        var isAuthorizedWithBiometices = false
        
        do {
            isAuthorizedWithBiometices = try await scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock your crypto portfolio")
        } catch {
            print("Failed to make auth with biometrics")
        }
        
        if isAuthorizedWithBiometices {
            authStatus = .successfullyAuthorized
        }
        
    }
    
    func numpadButtonWasPressed(number: Int) {
        HapticManager.notification(type: .warning)
        pincodeInput.append(String(number))
        
        if pincodeInput.count == 4 {
            makeAuthWithPincodeInput()
        }
    }
    
    func numpadRemoveButtonWasPressed() {
        HapticManager.notification(type: .warning)
        pincodeInput.removeLast()
    }
    
        // MARK: - Private
    
    private func makeAuthWithPincodeInput() {
        print("makeAuthFromPincodeInput called")
        let pincode = pincodeInput.joined()
        print(pincode)
        if pincode == "1111" {
            print("success")
            authStatus = .successfullyAuthorized
            pincodeInput.removeAll()
        } else {
            print("fail")
            authStatus = .wrongPassword
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.authStatus = .unathorized
                self.pincodeInput.removeAll()
            }
        }
    }
}
