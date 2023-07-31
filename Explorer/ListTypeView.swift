//
//  ListTypeView.swift
//  Explorer
//
//  Created by Jack Devey on 30/07/2023.
//

import SwiftUI

struct ListTypeView: View {
    
    @Binding var path: NavigationPath
    var type: Category
    @EnvironmentObject var locationDelegate: LocationDelegate
    
    var body: some View {
        switch locationDelegate.state {
        case .idle:
            ProgressView()
        case .loading:
            ProgressView()
        case .failed:
            ContentUnavailableView("No locations", systemImage: type.icon, description: Text("Error"))
                .symbolVariant(.slash)
        case .loaded:
            ScrollViewReader { content in
                List(locationDelegate.searchResults, id: \.self) { result in
                    NavigationLink(value: result) {
                        LocationListView(location: result)
                    }
                }
                .navigationTitle(type.name)
                .toolbar {
                    ToolbarItem {
                        Button {
                            let location = locationDelegate.searchResults.randomElement()
                            withAnimation {
                                content.scrollTo(location, anchor: .center)
                                path.append(location!)
                            }
                        } label: {
                            Label("Random", systemImage: "dice")
                        }
                    }
                }
            }
        }
    }
}
