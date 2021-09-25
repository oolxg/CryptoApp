    //
    //  Home.swift
    //  CryptoApp
    //
    //  Created by mk.pwnz on 26.05.2021.
    //

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolioView: Bool = false // show new sheet
    @State private var showPortfolio: Bool = false     // animate button
    @State private var showDetailView: Bool = false
    @State private var selectedCoin: Coin? = nil
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
                // background
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, onDismiss: {
                    vm.searchText = ""
                    vm.selectedCoin = nil
                }) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
            VStack {
                homeHeader
                
                HomeStatisticView(showPortfolio: $showPortfolio)
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortfolio {
                    allCoinsList
                        .transition(.move(edge: .leading))
                }
                
                if showPortfolio {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            portfolioEmptyText
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                AppInfoView()
            }
        }
        .background(
            NavigationLink(
                destination: DetailLoadingView(coin: $selectedCoin),
                isActive: $showDetailView,
                label: { EmptyView() }
            )
        )
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .animation(.none)
                .background(CircleButtonAnimationView(animate: $showPortfolio))
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
        
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(action: {
                            showPortfolioView = true
                            vm.selectedCoin = coin
                            vm.searchText = coin.symbol.uppercased()
                        }, label: {
                            Image(systemName: "plus")
                        })
                            .tint(.green)
                        
                    }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            vm.reloadData()
        }
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(action: {
                            vm.updatePortfolio(coin: coin, amount: 0)
                        }, label: {
                            Image(systemName: "trash.fill")
                        })
                        .tint(.red)
                        
                        Button(action: {
                            showPortfolioView = true
                            vm.selectedCoin = coin
                            vm.searchText = coin.symbol.uppercased()
                            vm.coinsQuantityText = coin.currentHoldings?.asNumberString() ?? ""
                        }, label: {
                            Image(systemName: "gear")
                        })
                       
                    }
            }
            
        }
        .listStyle(PlainListStyle())
        .refreshable {
            vm.reloadData()
        }
    }
    
    private func removeCoinsFromPortfolio(at offsets: IndexSet) {
        let coinsToUpdate = offsets.map { vm.portfolioCoins[$0] }
        for coin in coinsToUpdate {
            vm.updatePortfolio(coin: coin, amount: 0)
        }
    }
    
    private var portfolioEmptyText: some View {
        Text("No coins in portfolio. \n Maybe should add something? 🤔")
            .font(.callout)
            .foregroundColor(.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles: some View {
        HStack {
            columnTitleCoin
            
            Spacer()
            
            if showPortfolio {
                columnTitleHoldings
            }
            
            columnTitlePrice
            
//            Button(action: {
//                withAnimation(.linear(duration: 2)) {
//                    vm.reloadData()
//                }
//            }, label: {
//                Image(systemName: "goforward")
//            })
//                .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private var columnTitleCoin: some View {
        HStack(spacing: 4) {
            Text("Coin")
            Image(systemName: "chevron.down")
                .opacity(
                    vm.sortOption == .rank ||
                    vm.sortOption == .rankReversed ? 1 : 0
                )
                .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
        }
        .onTapGesture {
            withAnimation(.default) {
                vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
            }
        }
    }
    
    private var columnTitleHoldings: some View {
        HStack(spacing: 4) {
            Text("Holdings")
            Image(systemName: "chevron.down")
                .opacity(
                    vm.sortOption == .holdings ||
                    vm.sortOption == .holdingsReversed ? 1 : 0
                )
                .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
        }
        .onTapGesture {
            withAnimation(.default) {
                vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
            }
        }
    }
    
    private var columnTitlePrice: some View {
        HStack(spacing: 4) {
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            Image(systemName: "chevron.down")
                .opacity(
                    vm.sortOption == .price ||
                    vm.sortOption == .priceReversed ? 1 : 0
                )
                .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
        }
        .onTapGesture {
            withAnimation(.default) {
                vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
    }
}
