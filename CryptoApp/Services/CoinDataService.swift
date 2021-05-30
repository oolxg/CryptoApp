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
    private var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h")
        else { return }
        
        coinSubscription = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                    case .finished:
                        break
                    case .failure(let err):
                        print(err.localizedDescription)
                }
            } receiveValue: { [weak self] returnCoins in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()    
            }
    }
    
}
