//
//  Data.swift
//  CryptoApp
//
//  Created by mk.pwnz on 08/01/2022.
//

import Foundation


extension Data {
    func asString(encoding: String.Encoding = .utf8) -> String? {
        String(data: self, encoding: encoding)
    }
}
