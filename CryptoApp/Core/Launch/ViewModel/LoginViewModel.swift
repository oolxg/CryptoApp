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
    @Published private(set) var failedLoginWithBiometrics: Int = 0
    @Published private(set) var scaleAmountsForCirles = [1.0, 1.0, 1.0, 1.0]
    @Binding private var isSuccessfullyAuthorized: Bool
    @KeyChain(key: Constants.KeyChain.pincodeKey, account: Constants.KeyChain.account) private var userPincode
    private var authSubscription: AnyCancellable? = nil
    
    // MARK: - Computable variables
    var biometryAuthIconName: String {
        LAContext().biometricType == .faceID ? "faceid" : "touchid"
    }
    
    var isMionetryAuthDisabled: Bool {
        failedLoginWithBiometrics >= 3 || LAContext().biometricType == .none
    }
    
    var isNumpadDisabled: Bool {
        pincodeInput.count == 4 || authStatus == .successfullyAuthorized
    }
    
    var isRemoveButtonHidden: Bool {
        pincodeInput.count == 0 || authStatus != .unathorized
    }
    // MARK: - Computable variables end
    
    enum AuthStatus {
        case successfullyAuthorized, unathorized, wrongPassword
    }
    
    init(isSuccessfullyAuthorized: Binding<Bool>) {
        self._isSuccessfullyAuthorized = isSuccessfullyAuthorized
        addSubscriptions()
    }
    
    func makeBiometricAuth() async {
        let scanner = LAContext()
        
        var isAuthorizedWithBiometices = false
        
        do {
            isAuthorizedWithBiometices = try await scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock your crypto portfolio")
        } catch LAError.authenticationFailed {
            failedLoginWithBiometrics += 1
            print("User gave wrong Biometric credentials")
        } catch {
            printLAError(error)
        }
        
        if isAuthorizedWithBiometices {
            DispatchQueue.main.async {
                self.authStatus = .successfullyAuthorized
                self.pincodeInput = "0000".components(separatedBy: "")
            }
        }
    }
    
    func numpadButtonWasPressed(number: Int) {
        HapticManager.notification(type: .warning)
        pincodeInput.append(String(number))
        
        makeCirclePulsate()
        
        if pincodeInput.count == 4 {
            makeAuthWithPincodeInput()
        }
    }
    
    func numpadRemoveButtonWasPressed() {
        HapticManager.notification(type: .warning)
        if pincodeInput.count > 0 {
            pincodeInput.removeLast()
        }
    }
    
    // MARK: - Private
    
    private func printLAError(_ error: Error) {
        switch error {
            case LAError.appCancel:
                print("Authentication was cancelled by application")
            case LAError.authenticationFailed:
                print("The user failed to provide valid credentials")
            case LAError.invalidContext:
                print("The context is invalid")
            case LAError.passcodeNotSet:
                print("Passcode is not set on the device")
            case LAError.systemCancel:
                print("Authentication was cancelled by the system")
            case LAError.biometryLockout:
                print("Too many failed attempts.")
            case LAError.biometryNotAvailable:
                print("Biometry is not available on the device")
            case LAError.userCancel:
                print("The user did cancel")
            case LAError.userFallback:
                print("The user chose to use the fallback")
            default:
                print("Did not find error code on LAError object")
        }
    }
    
    private func addSubscriptions() {
        authSubscription = $authStatus
            .sink(receiveValue: { authStatus in
                if authStatus == .successfullyAuthorized {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.9..<1.6)) {
                        self.isSuccessfullyAuthorized = true
                    }
                }
            })
            
    }
    
    private func makeAuthWithPincodeInput() {
        
        guard authStatus == .unathorized else { return }
        guard let userPincodeString = userPincode?.asString() else {
            print("ERROR getting pincode from Key Chain")
            return
        }
        
        let pincode = pincodeInput.joined()
        if pincode == userPincodeString {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.authStatus = .successfullyAuthorized
                self.pincodeInput.removeAll()
            }
            
        } else {
            authStatus = .wrongPassword
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.authStatus = .unathorized
                self.pincodeInput.removeAll()
            }
        }
    }
    
    private func makeCirclePulsate(position: Int? = nil) {
        let circlePosition = position == nil ? pincodeInput.count - 1 : position!

        withAnimation(.linear(duration: 0.2)) {
            scaleAmountsForCirles[circlePosition] = 1.8
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 0.2)) {
                self.scaleAmountsForCirles[circlePosition] = 1.0
            }
        }
    }
}
