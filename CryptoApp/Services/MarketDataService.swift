//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by mk.pwnz on 06.06.2021.
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketData? = nil
    
    private var marketDataSubscription: AnyCancellable?
    
    init() {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else { return }
        
        marketDataSubscription = NetworkManager.download(from: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion,
                  receiveValue: { [weak self] returnedData in
                    self?.marketData = returnedData.data
                    self?.marketDataSubscription?.cancel()
                  })
    }
}
