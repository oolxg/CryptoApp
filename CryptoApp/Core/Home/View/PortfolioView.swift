//
//  PortfolioView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: HomeViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    
                    coinLogoList
                    
                    if vm.selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .navigationTitle("Edit portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton {
                        vm.searchText = ""
                        self.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavbarButton
                }
            })
        }
        .accentColor(.theme.accent)
        .onChange(of: vm.searchText) { value in
            if value == "" {
                vm.removeSelectedCoin()
            }
        }
    }
}

extension PortfolioView {
    private var searchListCoins: [Coin] {
        // if there're coins in portfolio and search string is empty, than will be show allCoins,
        // otherwise will show portfolio coins
        vm.searchText.isEmpty && !vm.portfolioCoins.isEmpty ? vm.portfolioCoins : vm.allCoins
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
                                .stroke(vm.selectedCoin?.id == coin.id ?
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
                Text("Current price of \(vm.selectedCoin?.symbol.uppercased() ?? ""):")
                
                Spacer()
                
                Text("\(vm.selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
            }
            
            Divider()
            
            HStack {
                Text("Amount in portfolio: ")
                
                Spacer()
                
                TextField("Ex: 1.4", text: $vm.coinsQuantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                
                Spacer()
                
                Text(vm.getCurrentValueOfHoldings().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavbarButton: some View {
        HStack {
            
            if vm.showCheckmark {
                Image(systemName: "checkmark")
            }
            
            if vm.selectedCoin != nil && vm.selectedCoin?.currentHoldings != vm.coinsQuantityText.asDouble() {
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
        vm.selectedCoin = coin
        
        if let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = portfolioCoin.currentHoldings {
            vm.coinsQuantityText = "\(amount)"
        } else {
            vm.coinsQuantityText = ""

        }
        
    }
    
    private func saveButtonPressed() {
        guard let coin = vm.selectedCoin,
              let amount = vm.coinsQuantityText.asDouble() else { return }
        
        vm.updatePortfolio(coin: coin, amount: amount)
        
        
        withAnimation(.easeIn) {
            vm.showCheckmark = true
            vm.removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                vm.showCheckmark = false
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
