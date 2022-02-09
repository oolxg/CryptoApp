//
//  DetailViewModel.swift
//  CryptoApp
//
//  Created by mk.pwnz on 12.06.2021.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    private let coinDetailService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    @Published var coin: Coin
    
    @Published var overviewStatistic: [Statistic] = []
    @Published var detailStatistic: [Statistic] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    @Published var showPortfolioView: Bool = false
    
    init(coin: Coin) {
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin)
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistic)
            .sink { [weak self] returnedArrays in
                guard let self = self else { return }
                self.overviewStatistic = returnedArrays.overview
                self.detailStatistic = returnedArrays.details
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetail
            .sink { [weak self] coinDetail in
                guard let self = self else { return }

                self.coinDescription = coinDetail?.readableDescription ?? "N/A"
                self.websiteURL = coinDetail?.links?.homepage?.first ?? "N/A"
                self.redditURL = coinDetail?.links?.subredditURL ?? "N/A"
            }
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistic(coinDetail: CoinDetail?, coin: Coin) -> (overview: [Statistic], details: [Statistic]) {
        let overview = createOverview(coinDetail: coinDetail)
        
        let details = createDetailsForCoin(coin: coin, coinDetail: coinDetail)
        
        return (overview, details)
    }
    
    private func createOverview(coinDetail: CoinDetail?) -> [Statistic] {
        let price = coin.currentPrice > 10 ? coin.currentPrice.asCurrencyWith2Decimals() : coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Cap", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coin.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "$" + "\(coin.totalVolume?.formattedWithAbbreviations() ?? "")"
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        return [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ]
    }
    
    private func createDetailsForCoin(coin: Coin, coinDetail: CoinDetail?) -> [Statistic] {
        let high = (coin.high24H ?? 0) > 10 ? coin.high24H?.asCurrencyWith2Decimals() ?? "N/A" : coin.high24H?.asCurrencyWith6Decimals() ?? "N/A"
        let highStat = Statistic(title: "High 24h", value: high)
        
        let low = (coin.low24H ?? 0) > 10 ? coin.low24H?.asCurrencyWith2Decimals() ?? "N/A" : coin.low24H?.asCurrencyWith6Decimals() ?? "N/A"
        let lowStat = Statistic(title: "Low 24h", value: low)
        
        let priceChange = (coin.priceChange24H ?? 0) > 10 ? coin.priceChange24H?.asCurrencyWith2Decimals() ?? "N/A" : coin.priceChange24H?.asCurrencyWith6Decimals() ?? "N/A"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)
        
        let blockTime = coinDetail?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "N/A" : "\(blockTime)"
        let blockTimeStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashingAlgo = coinDetail?.hashingAlgorithm ?? "N/A"
        let hashingAlgoStat = Statistic(title: "Hashing Algorithm", value: hashingAlgo)
        
        return [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat,
            blockTimeStat,
            hashingAlgoStat
        ]
    }
}
