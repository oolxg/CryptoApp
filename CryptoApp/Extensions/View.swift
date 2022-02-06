//
//  View.swift
//  CryptoApp
//
//  Created by mk.pwnz on 29.11.2021.
//

import Foundation
import SwiftUI


extension View {
    @ViewBuilder func hidden(_ hidden: Bool) -> some View {
        if !hidden {
            self
        }
    }
    
    func hud<Content: View>(isPresented: Binding<Bool>,
                            transition: AnyTransition = .move(edge: .top).combined(with: .opacity),
                            hideAfter hideInterval: Double = 3,
                            @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack(alignment: .top) {
            self
            
            if isPresented.wrappedValue {
                HUD {
                    content()
                }
                    .transition(transition)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + hideInterval) {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                .zIndex(1)
                
            }
        }
        
    }
}
