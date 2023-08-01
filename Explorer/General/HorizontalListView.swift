//
//  HorizontalListView.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import SwiftUI

struct HorizontalListView<Data, Content>: View where Data: Identifiable, Data: Hashable, Content: View {
            
    // Information to iterate over the list
    let data: [Data]
    let content: (Data) -> Content
    
    // Custom title and subtitle to describe data
    let title: String
    let subtitle: String?
    
    init(_ data: [Data], title: String, subtitle: String? = nil, @ViewBuilder content: @escaping (Data) -> Content) {
        // Set data & content
        self.data = data
        self.content = content
        // Also set title & subtitle if provided
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Show a grid of content views for
            // further detail
            NavigationLink {
                // Show a scrollable detail grid that shows all values
                ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        ForEach(data) { data in
                            content(data)
                        }
                    }
                    .padding([.horizontal], 20)
                }
                .navigationTitle(title)
            } label: {
                // Show title & subtitle (if provided)
                // as label for button
                VStack(alignment: .leading) {
                    HStack {
                        Text(title)
                            .foregroundStyle(Color.primary)
                            .font(.title2)
                            .bold()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.secondary)
                            .bold()
                    }
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            .padding([.horizontal], 20)
            
            // The actual horizontal scroll view with
            // view alignment on scroll.
            
            ScrollView(.horizontal) {
                LazyHStack {
                    // Iterate over data
                    ForEach(data.prefix(5)) { data in
                        // Show specified content view
                        content(data)
                            .frame(width: 300, height: 180) 
                    }
                }
                .scrollTargetLayout()
                .padding([.horizontal], 20)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
        }
        .padding(.bottom, 20)
    }
}
