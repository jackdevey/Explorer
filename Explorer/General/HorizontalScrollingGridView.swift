//
//  HorizontalListView.swift
//  Explorer
//
//  Created by Jack Devey on 31/07/2023.
//

import SwiftUI

struct HorizontalScrollingGridView<Data, Content>: View where Data: Identifiable, Data: Hashable, Content: View {
            
    // Information to iterate over the list
    let data: [Data]
    let content: (Data) -> Content
    
    // The shape of the data
    let shape: [[Data]]
    
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
        // Split data into 3x3 shape
        self.shape = [[data[0], data[1], data[2]], [data[3], data[4], data[5]], [data[6], data[7], data[8]]]
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Show a grid of content views for
            // further detail
            NavigationLink {
                // Show a scrollable list that shows all values
                List {
                    ForEach(data) { data in
                        content(data)
                    }
                }
                .listStyle(.plain)
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
                    VStack {
                        ForEach(shape[0], id: \.self) { data in
                            content(data)
                                .frame(width: 250)
                        }
                    }
                    VStack {
                        ForEach(shape[1], id: \.self) { data in
                            content(data)
                                .frame(width: 250)
                        }
                    }
                    VStack {
                        ForEach(shape[2], id: \.self) { data in
                            content(data)
                                .frame(width: 250)
                        }
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

extension Array where Element: ExpressibleByIntegerLiteral {
    init(rows: Int, columns: Int, repeating repeatedValue: Element) {
        self = Array(repeating: Array(repeating: repeatedValue, count: columns) as! Element, count: rows)
    }
}
