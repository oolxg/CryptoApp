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
    
    init(coin: Coin) {
        coinDetailService = CoinDetailDataService(coin: coin)
        
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetail
            .sink { returnedCoinDetails in
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
