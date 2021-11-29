    //
    //  LaunchViewModel.swift
    //  CryptoApp
    //
    //  Created by mk.pwnz on 28.11.2021.
    //

import Foundation
import Combine
import LocalAuthentication
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var authStatus: AuthStatus = .unathorized
    @Published private(set) var pincodeInput: [String] = []
    @Published private(set) var failedLoginWithBiometricsCount: Int = 0
    @Published var scaleAmountsForCirles = [1.0, 1.0, 1.0, 1.0]
    
    // MARK: - Computable variables
    var authIconName: String {
        LAContext().biometricType == .faceID ? "faceid" : "touchid"
    }
    
    var isAuthWithBiometricsAvailable: Bool {
        failedLoginWithBiometricsCount < 3 && LAContext().biometricType != .none
    }
    
    var isNumpadDisabled: Bool {
        pincodeInput.count == 4 || authStatus == .successfullyAuthorized
    }
    
    var isRemoveButtonAvailable: Bool {
        pincodeInput.count > 0 && authStatus == .unathorized
    }
    // MARK: - Computable variables end
    
    enum AuthStatus {
        case successfullyAuthorized, unathorized, wrongPassword
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
            DispatchQueue.main.async {
                self.authStatus = .successfullyAuthorized
                self.pincodeInput = "0000".components(separatedBy: "")
            }
            
        }
        
    }
    
    func numpadButtonWasPressed(number: Int) {
        let circleNumber = pincodeInput.count
        HapticManager.notification(type: .warning)
        pincodeInput.append(String(number))
        
        withAnimation(.linear(duration: 0.2)) {
            scaleAmountsForCirles[circleNumber] = 1.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 0.2)) {
                self.scaleAmountsForCirles[circleNumber] = 1.0
            }
        }
        
        
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
        
        guard authStatus == .unathorized else { return }
        
        let pincode = pincodeInput.joined()
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
