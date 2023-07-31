//
//  SubscriptionView.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import SwiftUI
import StoreKit

struct ExplorerPlusSubscriptionView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
        
    var body: some View {
        SubscriptionStoreView(productIDs: purchaseManager.productIds) {
            VStack {
                Text("Explorer+")
                    .font(.largeTitle)
                    .fontWeight(.black)
                
                Text("Take your exploration journey to the next level by subscribing to Explorer+!")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .foregroundStyle(.white)
            .containerBackground(.accent.gradient, for: .subscriptionStore)
        }
        .storeButton(.visible, for: .restorePurchases, .cancellation)
        .subscriptionStoreControlStyle(.prominentPicker)
        .onInAppPurchaseStart { product in
            print("User has started buying \(product.id)")
        }
        .onInAppPurchaseCompletion { product, result in
            await purchaseManager.handlePurchaseCompletion(product: product, result: result)
        }
    }
}
