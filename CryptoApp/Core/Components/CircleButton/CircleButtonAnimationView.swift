//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by mk.pwnz on 26.05.2021.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: animate ? 1 : 5)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? .easeOut(duration: 1) : nil, value: animate)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 200, height: 200)
        
    }
}
