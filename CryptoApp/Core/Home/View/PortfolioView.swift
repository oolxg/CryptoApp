//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var homeVM: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $homeVM.searchText)
                    
                    coinLogoList
                    
                    if homeVM.selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton {
                        homeVM.searchText = ""
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavbarButton
                }
            })
        }
        .accentColor(.theme.accent)
        .onChange(of: homeVM.searchText) { value in
            if value == "" {
                homeVM.removeSelectedCoin()
            }
        }
    }
}

extension PortfolioView {
    private var searchListCoins: [Coin] {
        // if there're coins in portfolio and search string is empty, than will be show allCoins,
        // otherwise will show portfolio coins
        homeVM.searchText.isEmpty && !homeVM.portfolioCoins.isEmpty ? homeVM.portfolioCoins : homeVM.allCoins
    }
    
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(searchListCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                updateSelectedCoins(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(homeVM.selectedCoin?.id == coin.id ?
                                            Color.theme.green : .clear,
                                        lineWidth: 1))
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(homeVM.selectedCoin?.symbol.uppercased() ?? ""):")
                
                Spacer()
                
                Text("\(homeVM.selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
            }
            
            Divider()
            
            HStack {
                Text("Amount in portfolio: ")
                
                Spacer()
                
                TextField("Ex: 1.4", text: $homeVM.coinsQuantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                
                Spacer()
                
                Text(homeVM.getCurrentValueOfHoldings().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavbarButton: some View {
        HStack {
            
            if homeVM.showCheckmark {
                Image(systemName: "checkmark")
            }
            
            if homeVM.selectedCoin != nil && homeVM.selectedCoin?.currentHoldings != homeVM.coinsQuantityText.asDouble() {
                Button(action: {
                    saveButtonPressed()
                }, label: {
                    Text("Save".uppercased())
                        .font(.headline)
                })
            }
        }
    }
    
    private func updateSelectedCoins(coin: Coin) {
        homeVM.selectedCoin = coin
        
        if let portfolioCoin = homeVM.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            homeVM.coinsQuantityText = "\(amount)"
        } else {
            homeVM.coinsQuantityText = ""

        }
        
    }
    
    private func saveButtonPressed() {
        guard let coin = homeVM.selectedCoin,
              let amount = homeVM.coinsQuantityText.asDouble() else { return }
        
        homeVM.updatePortfolio(coin: coin, amount: amount)
        
        
        withAnimation(.easeIn) {
            homeVM.showCheckmark = true
            homeVM.removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                homeVM.showCheckmark = false
            }
        }
    }

}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
