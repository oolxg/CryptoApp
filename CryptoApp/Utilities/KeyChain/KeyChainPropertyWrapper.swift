//
//  KeyChainPropertyWrapper.swift
//  CryptoApp
//
//  Created by mk.pwnz on 08/01/2022.
//

import Foundation
import SwiftUI

@propertyWrapper
struct KeyChain: DynamicProperty {
    @State var data: Data?
    
    var wrappedValue: Data? {
        get { KeyChainHelper.shared.read(key: key, forAccount: account ) }
        set {
            guard let newData = newValue else {
                // if setting data to `nil`
                // delete it from the Key Chain
                data = nil
                KeyChainHelper.shared.delete(key: key, account: account)
                return
            }
            KeyChainHelper.shared.save(data: newData, forKey: key, account: account)
            data = newData
        }
    }
    
    var key: String
    var account: String
    
    init(key: String, account: String) {
        self.key = key
        self.account = account
        
        _data = State(wrappedValue: KeyChainHelper.shared.read(key: key, forAccount: account))
    }
}
