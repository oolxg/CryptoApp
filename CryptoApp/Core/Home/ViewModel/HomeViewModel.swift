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
    private let portfolioDataService = PortfolioDataService()
    
    
    init() {
        addSubscribers()
    }
    
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    // MARK: Private
    
    private func addSubscribers() {
        // search in all coins
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest(coinDataService.$allCoins)
            .map(filterCoins)
            .sink { [weak self] coins in
                self?.allCoints = coins
            }
            .store(in: &cancellables)
        
        // search in portfolio coins
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest($portfolioCoins)
            .map(filterCoins)
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellables)
        
        // update marketData
        marketDataService
            .$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.stats = stats
            }
            .store(in: &cancellables)
        
        // load coins from CoreData
        $allCoints
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                self?.portfolioCoins = coins
            }
            .store(in: &cancellables)
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioCoins: [Portfolio]) -> [Coin] {
        allCoints.compactMap { coin -> Coin? in
            guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else {
                return nil
            }
            
            return coin.updateHoldings(amount: entity.amount)
        }
    }
    
    private func filterCoins(searchText: String, coins: [Coin]) -> [Coin] {
        guard !searchText.isEmpty else { return coins }
        
        let lowercased = searchText.lowercased()
        return coins.filter { coin -> Bool in
            coin.name.lowercased().contains(lowercased) ||
                coin.symbol.lowercased().contains(lowercased) ||
                coin.id.lowercased().contains(lowercased)
        }
    }
    
    private func mapGlobalMarketData(marketDataModel: MarketData?, portfolioCoins: [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketDataModel else { return stats }
        
        let marketCap = Statistic(title: "Market Cap",
                                  value: data.marketCap,
                                  percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map { $0.currentHoldingsValue }
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentCahnge = coin.priceChangePercentage24H ?? 0 / 100
                let previousValue = currentValue / (1 + percentCahnge)
                
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = (portfolioValue - previousValue) / previousValue
        
        let portfolio = Statistic(title: "Portfolio Value",
                                  value: portfolioValue.asCurrencyWith2Decimals(),
                                  percentageChange: percentageChange.isNaN ? 0 : percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
}
