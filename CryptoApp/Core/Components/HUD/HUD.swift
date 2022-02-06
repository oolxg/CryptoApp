//
//  HUD.swift
//  CryptoApp
//
//  Created by mk.pwnz on 06/02/2022.
//

import SwiftUI

struct HUD<Content: View>: View {
    @ViewBuilder var content: Content
    let backgroundColor: Color = .theme.red
    let opacity: Double = 0.8
    
    var body: some View {
        content
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
        HUD {
            Text("Hello world")
        }
        .padding()
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
        
        HUD {
            Text("Hello world")
        }
        .padding()
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)

    }
}
