//
//  SettingsView.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @State var showingExplorerPlusView = false
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink {
                    
                } label: {
                    Label("About", systemImage: "info.circle")
                }
                
                
                // If not subscribed to Explorer+
                if !purchaseManager.isExplorerPlusSubscriber {
                    Section {
                        Button {
                            showingExplorerPlusView = true
                        } label: {
                            Label("Get Explorer+", systemImage: "plus.circle")
                        }
                    } footer: {
                        Text("Take your exploration journey to the next level by subscribing to Explorer+!")
                    }
                } else {
                    ExplorerPlusBenefits()
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingExplorerPlusView) {
                ExplorerPlusSubscriptionView()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}
