//
//  CoinDetailDataService.swift
//  CryptoApp
//
//  Created by mk.pwnz on 12.06.2021.
//

import Foundation
import Combine

class CoinDetailDataService {
    let coin: Coin
    
    private var coinDetailsAPIurl: URL? {
        guard var components = URLComponents(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)") else { return nil }
        
        components.queryItems = [
            URLQueryItem(name: "localization", value: "false"),
            URLQueryItem(name: "tickers", value: "false"),
            URLQueryItem(name: "market_data", value: "false"),
            URLQueryItem(name: "community_data", value: "false"),
            URLQueryItem(name: "developer_data", value: "false"),
            URLQueryItem(name: "sparkline", value: "false")
        ]
        
        return components.url
    }
    
    @Published var coinDetail: CoinDetail? = nil
    
    private var coinDetailSubscription: AnyCancellable?
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = coinDetailsAPIurl else { return }
        
        coinDetailSubscription = NetworkManager.download(from: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returndeCoinDetail in
                    guard let self = self else { return }
                    self.coinDetail = returndeCoinDetail
                    self.coinDetailSubscription?.cancel()
                  })
    }
    
}
