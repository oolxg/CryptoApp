//
//  CoinDataService.swift
//  CryptoApp
//
//  Created by mk.pwnz on 30.05.2021.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [Coin] = []
    
    private let updateFrequency: TimeInterval =  60 / 8 // update frequency in seconds
    private var coinSubscription: AnyCancellable?
    private var updateCoinSubscription: AnyCancellable?
    
    init() {
        getCoins()
        setSubrciptions()
    }
    
    private func setSubrciptions() {
        updateCoinSubscription = Timer.publish(every: updateFrequency, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.getCoins()
            }
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h")
        else { return }
        
        coinSubscription = NetworkManager.download(from: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
