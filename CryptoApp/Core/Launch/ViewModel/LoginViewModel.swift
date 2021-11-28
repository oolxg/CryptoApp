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
    @Published var isAuthorized: Bool = false
    @Published var pincodeInput: [Int] = []
    private var cancellables = Set<AnyCancellable>()
    var authIconName: String {
        LAContext().biometryType == .faceID ? "faceid" : "touchid"
    }
    
    func makeBiometricAuth() -> Bool {
        let scanner = LAContext()
        
        guard scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) else {
            return false
        }
        
        
        return true
    }
    
    // MARK: - Private
    
    private func addSubscriptions() {
        $pincodeInput
            .sink { _ in
                if self.pincodeInput.count == 4 {
                    self.makeAuthFromPincodeInput()
                }
            }
            .store(in: &cancellables)
    }
    
    private func makeAuthFromPincodeInput() {
        
    }
}
