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
    
    @Published var stats: [Statistic] = []
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        coinDataService
            .$allCoins
            .sink { [weak self] coins in
                self?.allCoints = coins
            }
            .store(in: &cancellables)
        
        // update marketData
        marketDataService
            .$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.stats = stats
            }
            .store(in: &cancellables)
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketData?) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = Statistic(title: "Portfolio Value", value: "$0.00")
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolioValue])
        
        return stats
    }
}
