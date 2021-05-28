//
//  ContentView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 25.05.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.red.ignoresSafeArea()
            
            VStack {
                Text("Secondary text color")
                    .foregroundColor(.theme.secondaryText)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
