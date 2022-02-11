//
//  Constants.swift
//  CryptoApp
//
//  Created by mk.pwnz on 08/01/2022.
//

import Foundation


struct Constants { }

extension Constants {
    struct AppSettings {
        struct Privacy {
            static let isPasswordSecurityActive: String = "isPasswordSecurityActive"
            static let appAutoLockTime: String = "appAutoLockTime"
            static let useBiometryToUnlock: String = "useBiometryToUnlock"
            // needs to check when user last time used the app, before it was send in background
            static let lastActiveSessionTimestamp: String = "lastACtiveSessionTimestamp"
        }
    }
}

extension Constants {
    struct KeyChain {
        static let account: String = "CryptoApp"
        static let pincodeKey: String = "user_pincode"
    }
}
