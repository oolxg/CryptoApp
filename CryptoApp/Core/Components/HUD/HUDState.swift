//
//  HUDState.swift
//  CryptoApp
//
//  Created by mk.pwnz on 07/02/2022.
//

import Foundation
import SwiftUI

// TODO: rewrite all the things here to title: , text:
// No more Content, i'm fucking tired

final class HUDState: ObservableObject {
    @Published var isPresented: Bool = false
    private(set) var text: String = ""
    private(set) var duration: Double = 5
    private(set) var iconName: String? = nil
    
    func show(text: String, iconName: String? = nil, withDuration duration: Double = 5) {
        self.text = text
        self.duration = duration
        self.iconName = iconName
        withAnimation {
            isPresented = true
        }
    }
}
