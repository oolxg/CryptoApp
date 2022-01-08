//
//  LoginScreen.swift
//  CryptoApp
//
//  Created by mk.pwnz on 28.11.2021.
//

import SwiftUI

struct LoginScreen: View {
    @ObservedObject var vm: LoginViewModel
    @Binding var isSuccessfullyAuthorized: Bool

    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 65, maximum: 95)),
        GridItem(.flexible(minimum: 65, maximum: 95)),
        GridItem(.flexible(minimum: 65, maximum: 95))
    ]
    
    init(isSuccessfullyAuthorized: Binding<Bool>) {
        _vm = .init(wrappedValue: LoginViewModel(isSuccessfullyAuthorized: isSuccessfullyAuthorized))
        _isSuccessfullyAuthorized = isSuccessfullyAuthorized
    }
    
    var body: some View {
        VStack {
            
            inputCircles
            
            numpadBlock
                .disabled(vm.isNumpadDisabled)
        }
        .task {
            await vm.makeBiometricAuth()
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen(isSuccessfullyAuthorized: .constant(false))
            .preferredColorScheme(.dark)
        
    }
}


extension LoginScreen {
    private var biometricLoginButton: some View {
        Button {
            Task.init {
                await vm.makeBiometricAuth()
            }
        } label: {
            Image(systemName: vm.biometryAuthIconName )
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
                    vm.numpadButtonWasPressed(number: num)
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
                vm.numpadButtonWasPressed(number: 0)
            } label: {
                Text("0")
                    .font(.largeTitle)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 25)
                    .foregroundColor(.white)
            }
            
            Button {
                vm.numpadRemoveButtonWasPressed()
            } label: {
                Image(systemName: "delete.left")
                    .foregroundColor(.theme.accent)
                    .font(.largeTitle)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 25)
                    .invisible(vm.isRemoveButtonAvailable)
            }
        }
    }
    
    private var inputCircles: some View {
        HStack {
            ForEach(0..<4) { num in
                if vm.authStatus == .unathorized {
                    // `vm.pincodeInput.count <= num` checks the position of the circle and the number of entered numbers
                    // if positin of th cricle is bigger, then number of entered numbers, the circle must be "empty"(stroke)
                    inputCircle(isStroke: vm.pincodeInput.count <= num, foregroundColor: .theme.accent)
                        .scaleEffect(vm.scaleAmountsForCirles[num])
                } else if vm.authStatus == .successfullyAuthorized {
                    inputCircle(foregroundColor: .theme.green)
                        .scaleEffect(vm.scaleAmountsForCirles[num])
                } else {
                    inputCircle(foregroundColor: .theme.red)
                        .scaleEffect(vm.scaleAmountsForCirles[num])
                }
            }
        }
    }
    
    @ViewBuilder private func inputCircle(isStroke: Bool = false, foregroundColor: Color) -> some View {
        if isStroke {
            Circle()
                .stroke()
                .frame(width: 13)
                .padding(10)
                .foregroundColor(foregroundColor)
        } else {
            Circle()
                .frame(width: 13)
                .padding(10)
                .foregroundColor(foregroundColor)
        }

    }
}
