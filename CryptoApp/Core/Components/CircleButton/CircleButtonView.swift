//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 26.05.2021.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String
    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(.theme.background)
            )
            .shadow(color: .theme.accent.opacity(0.25),
                    radius: 10, x: 0, y: 0)
            .padding()
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CircleButtonView(iconName: "plus")
                .previewLayout(.sizeThatFits)
            
            CircleButtonView(iconName: "info")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
