//
//  Date.swift
//  CryptoApp
//
//  Created by mk.pwnz on 14.06.2021.
//

import Foundation


extension Date {
    //  "2013-07-06T00:00:00.000Z"
    init(coinGeckoString: String) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        formatter.dateFormat = "dd/MM/yy"
        
        return formatter
    }
    
    func asShortDateString() -> String {
        shortFormatter.string(from: self)
    }
}
