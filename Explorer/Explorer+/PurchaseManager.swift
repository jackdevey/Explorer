//
//  PurchaseManager.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import Foundation
import StoreKit

@MainActor
class PurchaseManager: ObservableObject {
    
    let productIds = ["uk.jw3.Explorer.Explorerplus"]
    
    private var updates: Task<Void, Never>? = nil
    
    @Published
    private(set) var purchasedProductIds = Set<String>()
    
    
    init() {
        // Begin observing transaction updates
        updates = observeTransactionUpdates()
    }
    
    deinit {
        // Stop opbserving transaction updates
        updates?.cancel()
    }
    
    
    /**
     Checks if the user is a subscriber to Explorer+
     */
    
    public var isExplorerPlusSubscriber: Bool {
        self.purchasedProductIds.contains("uk.jw3.Explorer.Explorerplus")
    }

    
    /**
     Refreshes the `purchasedProductIds` set removing products whose transactions
     have been revoked.
     */
    
    public func updatePurchasedProducts() async {
        
        for await result in Transaction.currentEntitlements {
            // If transaction is verified
            guard case .verified(let transaction) = result else {
                continue
            }
            
            // If transaction has not been revoked
            if transaction.revocationDate == nil {
                self.purchasedProductIds.insert(transaction.productID)
            } else {
                self.purchasedProductIds.remove(transaction.productID)
            }
            
        }
        
    }
    
    
    /**
     Observe transaction updates in the backrgound for handling
     updates from App Store or other devices
     */
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        // Begin a background task for handling verified
        // transaction changes
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                // Update purchased products
                await self.updatePurchasedProducts()
            }
        }
    }
    
    /**
     Handles purchase completion by updating purchased list
     on successful transaction recorded.
     */
    
    public func handlePurchaseCompletion(product: Product, result: Result<Product.PurchaseResult, Error>) async {
        if case .success(.success) = result {
            await self.updatePurchasedProducts()
        }
    }
    
}
