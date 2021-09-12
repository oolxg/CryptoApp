//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by mk.pwnz on 09.06.2021.
//

import Foundation
import CoreData

class PortfolioDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "Portfolio"
    
    @Published var savedEntities: [Portfolio] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        
        container.loadPersistentStores { _, err in
            if let error = err {
                print("Error loading Core Data: \(error)")
            }
            self.getPortfolio()
        }
        
        
    }
    
    // MARK:- Public
    
    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                remove(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    // MARK:- Private
    
    private func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let err {
            print("Error fetching Portfolio Entites: \(err)")
        }
    }
    
    private func add(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        
        entity.coinID = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func update(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let err {
            print("Error saving Portfolio Entity: \(err)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
