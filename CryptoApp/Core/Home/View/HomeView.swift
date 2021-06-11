//
//  Home.swift
//  CryptoApp
//
//  Created by mk.pwnz on 26.05.2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolioView: Bool = false // show new shit
    @State private var showPortfolio = false // animate button

    var body: some View {
        ZStack {
            // backgroung
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
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
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
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
            ForEach(vm.allCoints) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var columnTitles: some View {
        HStack {
            columnTitleCoin
            
            Spacer()
            
            if showPortfolio {
                columnTitleHoldings
            }
            
            columnTitlePrice
            
            Button(action: {
                withAnimation(.linear(duration: 2)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            
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
