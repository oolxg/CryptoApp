//
//  DetailView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 11.06.2021.
//

import SwiftUI

struct DetailLoadingView: View {
    @Binding var coin: Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
    }
}

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @State private var showDescription: Bool = false
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    private var spacing: CGFloat = 30
    
    init(coin: Coin) {
        _vm = .init(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical )

                VStack(spacing: 20) {
                    
                    overview
                    
                    details
                    
                    description
                    
                    websiteSection
                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
               navigationBarTrailingItem
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(coin: dev.coin)
        }
    }
}


extension DetailView {
    private var navigationBarTrailingItem: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.theme.secondaryText)
            
            CoinImageView(coin: vm.coin)
                .frame(width: 30)
        }
    }
    
    private var details: some View {
        Group {
            Text("Details")
                .font(.title)
                .bold()
                .foregroundColor(.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: spacing) {
                
                ForEach(vm.detailStatistic) { stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
    private var overview: some View {
        Group {
            Text("Overview")
                .font(.title)
                .bold()
                .foregroundColor(.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            LazyVGrid(columns: columns,
                      alignment: .leading,
                      spacing: spacing) {
                
                ForEach(vm.overviewStatistic) { stat in
                    StatisticView(stat: stat)
                }
            }
        }
    }
    
    private var description: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text("Description")
                        .font(.title)
                        .bold()
                        .foregroundColor(.theme.accent)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    Text(coinDescription)
                        .lineLimit(showDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(.theme.secondaryText)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showDescription.toggle()
                        }
                    }, label: {
                        Text(showDescription ? "Less" :  "Read more..." )
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    })
                    .accentColor(.blue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                
            }
        }
    }
    
    private var websiteSection: some View {
    VStack(alignment: .leading, spacing: 20){
            
            if let websiteLink = vm.websiteURL,
               let url = URL(string: websiteLink) {
                Link("Website", destination: url)
            }
            
            if let redditLink = vm.redditURL,
               let redditURL = URL(string: redditLink) {
                Link("Subreddit", destination: redditURL)
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
