//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import SwiftUI

struct XMarkButton: View {
    
    @Binding var presentationMode: PresentationMode
    
    var body: some View {
        Button(action: {
            $presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}
