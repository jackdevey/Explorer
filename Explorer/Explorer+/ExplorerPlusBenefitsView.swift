//
//  ExplorerPlusBenefits.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import SwiftUI

struct ExplorerPlusBenefits: View {
    
    var body: some View {
        Section {
            NavigationLink {
                // Custom App Icons
            } label: {
                Label("App Icon", systemImage: "app")
            }
        } header: {
            Text("Explorer+ Benefits")
        }
        .headerProminence(.increased)
    }
}
