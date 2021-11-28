//
//  LoginScreen.swift
//  CryptoApp
//
//  Created by mk.pwnz on 28.11.2021.
//

import SwiftUI

struct LoginScreen: View {
    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 65, maximum: 95)),
        GridItem(.flexible(minimum: 65, maximum: 95)),
        GridItem(.flexible(minimum: 65, maximum: 95))
    ]
    @ObservedObject var vm: LoginViewModel = .init()
    var body: some View {
        VStack {
            
            HStack {
                ForEach(0..<4) { num in
                    if vm.pincodeInput.count <= num {
                        Circle()
                            .stroke()
                            .frame(width: 13)
                            .padding(10)
                            .foregroundColor(.theme.accent)
                    } else {
                        Circle()
                            .frame(width: 13)
                            .padding(10)
                            .foregroundColor(.theme.accent)
                    }
                    
                }
            }
            
            numpadBlock
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
            .preferredColorScheme(.dark)
        
    }
}


extension LoginScreen {
    private var biometricLoginButton: some View {
        Button {
            
        } label: {
            Image(systemName: vm.authIconName )
                .font(.title)
                .foregroundColor(.theme.accent)
                .background(Color.theme.background)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke()
                        .foregroundColor(.theme.accent)
                )
            
        }
    }
    
    private var numpadBlock: some View {
        LazyVGrid(columns: columns) {
            ForEach(1..<10) { num in
                Button {
                    vm.pincodeInput.append(num)
                } label: {
                    Text("\(num)")
                        .font(.largeTitle)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 25)
                        .foregroundColor(.white)
                }
                
            }
            
            biometricLoginButton
            
            Button {
                
            } label: {
                Text("0")
                    .font(.largeTitle)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 25)
                    .foregroundColor(.white)
            }
            
            if vm.pincodeInput.count > 0 {
                Button {
                    vm.pincodeInput.removeLast()
                } label: {
                    Image(systemName: "delete.left")
                        .foregroundColor(.theme.accent)
                        .font(.largeTitle)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 25)
                }
            }
            

        }
    }
}
