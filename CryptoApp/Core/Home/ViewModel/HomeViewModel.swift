//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.05.2021.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var allCoints: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.allCoints.append(DeveloperPreview.shared.coin)
            self.portfolioCoins.append(DeveloperPreview.shared.coin)
        }
    }
}
