//
//  CategoryLocationListView.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import SwiftUI
import ScalingHeaderScrollView

struct CategoryLocationListView: View {
        
    var body: some View {
        ScalingHeaderScrollView {
            ZStack {
                Rectangle()
                    .fill(.gray.opacity(0.15))
                Image("header")
            }
        } content: {
            Text("↓ Pull to refresh ↓")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}



