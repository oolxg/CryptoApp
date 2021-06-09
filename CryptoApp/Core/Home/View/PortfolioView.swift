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
    @StateObject var portfolioVM = PortfolioViewModel.shared
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $homeVM.searchText)
                    
                    coinLogoList
                    
                    if portfolioVM.selectedCoin != nil {
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
    }
}


extension PortfolioView {
    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(homeVM.allCoints) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                portfolioVM.selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(portfolioVM.selectedCoin?.id == coin.id ?
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
                Text("Current price of \(portfolioVM.selectedCoin?.symbol.uppercased() ?? ""):")
                
                Spacer()
                
                Text("\(portfolioVM.selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
            }
            
            Divider()
            
            HStack {
                Text("Amount in portfolio: ")
                
                Spacer()
                
                TextField("Ex: 1.4", text: $portfolioVM.coinsQuantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            
            Divider()
            
            HStack {
                Text("Current value:")
                
                Spacer()
                
                Text(portfolioVM.getCurrentValueOfHoldings().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavbarButton: some View {
        HStack {
            
            if portfolioVM.showCheckmark {
                Image(systemName: "checkmark")
            }
            
            if portfolioVM.selectedCoin != nil && portfolioVM.selectedCoin?.currentHoldings != portfolioVM.coinsQuantityText.asDouble() {
                Button(action: {
                    saveButtonPressed()
                }, label: {
                    Text("Save".uppercased())
                        .font(.headline)
                })
            }
        }
    }
    
    private func removeSelectedCoin() {
        portfolioVM.selectedCoin = nil
        homeVM.searchText = ""
    }
    
    private func saveButtonPressed() {
        guard let coin = portfolioVM.selectedCoin else { return }
        
        
        withAnimation(.easeIn) {
            portfolioVM.showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                portfolioVM.showCheckmark = false
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
