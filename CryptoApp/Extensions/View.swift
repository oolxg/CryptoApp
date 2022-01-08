//
//  View.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.11.2021.
//

import Foundation
import SwiftUI


extension View {
    @ViewBuilder func hidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
}
