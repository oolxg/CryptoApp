//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.05.2021.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoints: [Coin] = []
    @Published var portfolioCoins: [Coin] = []
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        dataService
            .$allCoins
            .sink { [weak self] coins in
                self?.allCoints = coins
            }
            .store(in: &cancellables)
    }
}
