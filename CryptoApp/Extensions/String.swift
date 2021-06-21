//
//  String.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import Foundation

extension String {
    /// Convert a `String` to a `Double`
    /// ```
    /// Convert "12" to 12.00
    /// Convert "-12" to -12.00
    /// Convert "123abcde4" to nil
    /// ```
    func asDouble() -> Double? {
        let formatter = NumberFormatter()
        
        formatter.decimalSeparator = "."
        
        if let result = formatter.number(from: self) {
            return result.doubleValue
        } else {
            formatter.decimalSeparator = ","
            if let result = formatter.number(from: self) {
                return result.doubleValue
            }
        }
        
        return nil
    }
    
    var removingHTMLOccurencies:  String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
