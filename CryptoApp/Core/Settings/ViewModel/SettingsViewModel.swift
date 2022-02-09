//
//  SettingsViewModel.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09/02/2022.
//

import Foundation
import SwiftUI


class SettingsViewModel: ObservableObject {
    @KeyChain(key: Constants.KeyChain.pincodeKey, account: Constants.KeyChain.account) private var userPincode

}
