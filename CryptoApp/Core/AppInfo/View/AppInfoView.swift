//
//  AppInfoView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 25.06.2021.
//

import SwiftUI

struct AppInfoView: View {
    let coinGeckoURL = URL(string: "https://coingecko.com")!
    let personalURL = URL(string: "https://mkwpnz.moe")!
    let telegegramURL = URL(string: "tg://resolve?domain=mkpwnz")!
    let githubURL = URL(string: "https://github.com/BlueGlassMoon/")!
    
    var body: some View {
        List {
            developerInfo
            
            appInfo
            
            coinGeckoInfo
        }
        .font(.headline)
        .accentColor(.blue)
        .listStyle(GroupedListStyle())
        .navigationTitle("About")
    }
}

struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}


extension AppInfoView {
    private var appInfo: some View {
        Section(header: Text("App Info")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("This app was made by @mkpwnz(me) with help of YouTube video-course. It uses MVVM, Combine, CoreData.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
        }
    }
    
    private var coinGeckoInfo: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text("Thanks to CoinGecko, whose free API was used in this app.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            
            Link("CoinGecko", destination: coinGeckoURL)
        }
    }
    
    private var developerInfo: some View {
        Section(header: Text("About me")) {
            VStack {
                Image("me")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(Circle())
                
                Text("My name is Oleg Mihajlov and this app was made by me. I'm a junior iOS developer, who is looking for a job.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            
            Link("Contact me on Telegram", destination: telegegramURL)
            Link("My Github", destination: githubURL)
        }
    }
}
