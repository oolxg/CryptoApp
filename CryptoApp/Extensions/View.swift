//
//  View.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.11.2021.
//

import Foundation
import SwiftUI


extension View {
    func hidden(_ isHidden: Bool = false) -> some View {
        self
            .opacity(isHidden ? 0 : 1)
            .disabled(isHidden)
    }
}
