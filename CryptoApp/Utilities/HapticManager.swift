//
//  HapticManager.swift
//  CryptoApp
//
//  Created by mk.pwnz on 11.06.2021.
//

import Foundation
import SwiftUI

class HapticManager {
    
    private static let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
