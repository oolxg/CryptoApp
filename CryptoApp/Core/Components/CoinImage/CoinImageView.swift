//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 01.06.2021.
//

import SwiftUI

struct CoinImageView: View {
    let coin: Coin
    
    var body: some View {
        AsyncImage(url: URL(string: coin.image)) { phase in
            switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(_):
                    Image(systemName: "exclamationmark.circle")
                        .foregroundColor(.red)
                case .empty:
                    ProgressView()
                @unknown default:
                    fatalError()
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
