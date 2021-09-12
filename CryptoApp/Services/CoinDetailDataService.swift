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
    
    @Published var coinDetail: CoinDetail? = nil
    
    private var coinDetailSubscription: AnyCancellable?
    
    init(coin: Coin) {
        self.coin = coin
        getCoinDetails()
    }
    
    func getCoinDetails() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false")
        else { return }
        
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
