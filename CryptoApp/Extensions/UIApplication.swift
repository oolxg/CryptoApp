//
//  UIApplication.swift
//  CryptoApp
//
//  Created by mk.pwnz on 03.06.2021.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
