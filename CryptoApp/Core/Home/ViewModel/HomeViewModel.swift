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
    @Published var isLoading: Bool = false
    @Published var stats: [Statistic] = []
    @Published var sortOption: SortOption = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellables = Set<AnyCancellable>()
    private let portfolioDataService = PortfolioDataService()
    
    enum SortOption {
        case rank, rankReversed
        case holdings, holdingsReversed
        case price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    // MARK: Private
    
    private func addSubscribers() {
        // search in all coins
        $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .map(filterAndSortCoins)
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
        
        // load coins from CoreData
        $allCoints
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] coins in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: coins)
            }
            .store(in: &cancellables)

        // update marketData
        marketDataService
            .$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] stats in
                self?.stats = stats
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
            case .rank, .holdings:
                coins.sort(by: { $0.rank < $1.rank })
            case .rankReversed, .holdingsReversed:
                coins.sort(by: { $0.rank > $1.rank })
            case .price:
                coins.sort(by: { $0.currentPrice > $1.currentPrice })
            case .priceReversed:
                coins.sort(by: { $0.currentPrice < $1.currentPrice })
                
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin] {
        switch sortOption {
            case .holdings:
                return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
            default:
                return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        }
    }
    
    private func filterAndSortCoins(searchText: String, coins: [Coin], sortOption: SortOption) -> [Coin] {
        var filteredCoins = filterCoins(searchText: searchText, coins: coins)
        
        sortCoins(sort: sortOption, coins: &filteredCoins)
        
        return filteredCoins
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
