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
            VStack(alignment: .leading) {
                ZStack {
                    Image(.explorerPlusBackground)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text("Explorer+")
                                .font(.largeTitle)
                                .bold()
                        }
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding()
                }
                .background(.explorerPlus)
                Text("Take your exploration journey to the next level with Explorer+!")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .containerBackground(.explorerPlus, for: .subscriptionStore)
        .storeButton(.visible, for: .restorePurchases, .cancellation)
        .subscriptionStoreControlStyle(.prominentPicker)
        .onInAppPurchaseStart { product in
            print("User has started buying \(product.id)")
        }
        .onInAppPurchaseCompletion { product, result in
            await purchaseManager.handlePurchaseCompletion(product: product, result: result)
        }
        .tint(.explorerPlus)
    }
}
