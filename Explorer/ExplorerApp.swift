//
//  ExplorerApp.swift
//  Explorer
//
//  Created by Jack Devey on 18/06/2023.
//

import SwiftUI

@main
struct ExplorerApp: App {
    
    @StateObject var purchaseManager = PurchaseManager()
    @StateObject var locationDelegate = LocationDelegate()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchaseManager)
                .environmentObject(locationDelegate)
                .task {
                    // Update purchased products to detect changes
                    // whilst app was closed
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
