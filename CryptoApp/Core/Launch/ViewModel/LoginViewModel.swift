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
    @Published private(set) var authStatus: AuthStatus = .unathorized
    @Published private(set) var pincodeInput: [String] = []
    @Published private(set) var failedLoginWithBiometrics: Int = 0
    @Published private(set) var scaleAmountsForCirles = [1.0, 1.0, 1.0, 1.0]
    @Published private(set) var isSuccessfullyAuthorized: Bool = false
    @KeyChain(key: Constants.KeyChain.pincodeKey, account: Constants.KeyChain.account) private var userPincode
    @AppStorage(Constants.AppSettings.Privacy.isPasswordSecurityActive) private var isPasswordSecurityActive: Bool = false
    @AppStorage(Constants.AppSettings.Privacy.useBiometryToUnlock) private var useBiometryToUnlock: Bool = false
    @AppStorage(Constants.AppSettings.Privacy.lastActiveSessionTimestamp) private var lastActiveSessionTimestamp: Double = Date().timeIntervalSince1970

    
    // indicates launchView status
    // normally if 'useBiometryToUnlock' == false after 0.5..<0.8 seconds this screens disappears
    @Published private(set) var _shouldShowLaunchView: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Computed variables
    var biometryAuthIconName: String {
        LAContext().biometricType == .faceID ? "faceid" : "touchid"
    }
    
    var isBiometryAuthAvailable: Bool {
        useBiometryToUnlock && failedLoginWithBiometrics < 3 && LAContext().biometricType != .none
    }
    
    var isNumpadDisabled: Bool {
        pincodeInput.count == 4 || authStatus == .successfullyAuthorized
    }
    
    var isRemoveButtonHidden: Bool {
        pincodeInput.count == 0 || authStatus != .unathorized
    }
    
    var shouldShowLaunchView: Bool {
        failedLoginWithBiometrics == 0 && !isSuccessfullyAuthorized && _shouldShowLaunchView
    }
    
    var shouldShowLoginView: Bool {
        !isSuccessfullyAuthorized && isPasswordSecurityActive
    }
    // MARK: - Computed variables end
    
    enum AuthStatus {
        case successfullyAuthorized, unathorized, wrongPassword
    }
    
    init() {
        addSubscriptions()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.5..<0.8)) {
            if !self.useBiometryToUnlock {
                self._shouldShowLaunchView = false
            }
            
            // if there's no password, user is authorized as he opens the app
            if !self.isPasswordSecurityActive {
                self.authStatus = .successfullyAuthorized
            }
        }
    }
    
    func handleNewScenePhase(_ newScenePhase: ScenePhase) {
        switch newScenePhase {
            case .inactive:
                lastActiveSessionTimestamp = Date().timeIntervalSince1970
            case .background, .active:
                break
            @unknown default:
                fatalError("New type of scenePhase. Must handle it!")
        }
    }
    
    func tryMakeBiometryAuth() async {
        guard useBiometryToUnlock else {
            print("User disabled biometry auth in app settings")
            return
        }
        
        let scanner = LAContext()
        
        var isAuthorizedWithBiometices = false
        
        do {
            isAuthorizedWithBiometices = try await scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To unlock your crypto portfolio")
        } catch {
            DispatchQueue.main.async {
                self.failedLoginWithBiometrics += 1
            }
            printLAError(error)
        }
        
        if isAuthorizedWithBiometices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.4..<0.6)) {
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
        $authStatus
            .filter { $0 == .successfullyAuthorized }
            .debounce(for: .seconds(Double.random(in: 0.6..<1.0)), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] authStatus in
                guard let self = self else { return }
                self.isSuccessfullyAuthorized = true
            })
            .store(in: &cancellables)
            
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
