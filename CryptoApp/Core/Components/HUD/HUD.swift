//
//  HUD.swift
//  CryptoApp
//
//  Created by mk.pwnz on 06/02/2022.
//

import SwiftUI

struct HUD: View {
    let backgroundColor: Color
    let opacity: Double = 0.8
    let iconName: String?
    let text: String
    
    init(text: String, iconName: String? = nil, backgroundColor: Color = .theme.red) {
        self.text = text
        self.iconName = iconName
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        HStack {
            if let iconName = iconName {
                Image(systemName: iconName)
            }
            Text(text)
        }
        .padding(.horizontal, 12)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(backgroundColor)
                .opacity(opacity)
                .shadow(color: Color(.black).opacity(0.16), radius: 25, x: 0, y: 5)
        )
    }
}

struct HUDView_Previews: PreviewProvider {
    static var previews: some View {
        HUD(text: "Hello world", iconName: "hand.thumbsup")
            .padding()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        HUD(text: "Hello world")
            .padding()
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)

    }
}
