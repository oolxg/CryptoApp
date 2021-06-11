//
//  PortfolioViewModel.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import Foundation
import Combine

class PortfolioViewModel: ObservableObject {
    @Published var selectedCoin: Coin? = nil
    @Published var coinsQuantityText: String = ""
    @Published var showCheckmark: Bool = false
    
    func getCurrentValueOfHoldings() -> Double {
        if let quantity = coinsQuantityText.asDouble() {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    func removeSelectedCoin() {
        selectedCoin = nil
    }
}
