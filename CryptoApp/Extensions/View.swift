//
//  View.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.11.2021.
//

import Foundation
import SwiftUI


extension View {
    func invisible(_ isVisible: Bool = false) -> some View {
        self
            .opacity(isVisible ? 1 : 0)
            .disabled(!isVisible)
    }
}
