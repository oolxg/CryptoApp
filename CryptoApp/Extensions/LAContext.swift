//
//  LAContext.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.11.2021.
//

import Foundation
import LocalAuthentication

extension LAContext {
    
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }
    
    var biometricType: BiometricType {
        var error: NSError?
        
        guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch self.biometryType {
                case .none:
                    return .none
                case .touchID:
                    return .touchID
                case .faceID:
                    return .faceID
                @unknown default:
                    fatalError("The new biometry type was added. Should handle it")
            }
        }
        
        return self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
}
