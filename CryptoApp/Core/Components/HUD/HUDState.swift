//
//  HUDState.swift
//  CryptoApp
//
//  Created by mk.pwnz on 07/02/2022.
//

import Foundation
import SwiftUI



final class HUDState: ObservableObject {
    @Published var isPresented: Bool = false
    private(set) var text: String = ""
    private(set) var duration: Double = 5
    private(set) var iconName: String? = nil
    private(set) var backgroundColor: Color = .theme.red
    
    static var shared: HUDState = HUDState()
    
    private init () { }
    
    func show(text: String, iconName: String? = nil, withDuration duration: Double = 5, backgroundColor: Color = .theme.red) {
        self.text = text
        self.duration = duration
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        withAnimation {
            isPresented = true
        }
    }
}
