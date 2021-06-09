//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import SwiftUI

struct XMarkButton: View {

    let action: () -> ()
    
    var body: some View {
        Button(action: action, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}


struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton {
            
        }
            .environmentObject(dev.homeVM)
    }
}
