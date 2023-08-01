//
//  ListTypeView.swift
//  Explorer
//
//  Created by Jack Devey on 30/07/2023.
//

import SwiftUI
import MapKit

struct ListTypeView: View {
    
    @Binding var path: NavigationPath
    var type: Category
    @EnvironmentObject var locationDelegate: LocationDelegate
    @EnvironmentObject var feedbackManager: FeedbackManager
    
    @State var randomLocationIsPresented: Bool = false
    
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
                    LocationListView(location: result)
                    
                }
                .navigationTitle(type.name)
                .toolbar {
                    ToolbarItem {
                        Button {
                            self.feedbackManager.rigid()
                            self.randomLocationIsPresented.toggle()
                        } label: {
                            Label("Random", systemImage: "dice")
                        }
                    }
                }
            }
            .sheet(isPresented: $randomLocationIsPresented) {
                LocationDetailView(isPresented: $randomLocationIsPresented, location: locationDelegate.searchResults.randomElement()!)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .onChange(of: randomLocationIsPresented) { hidden, showing in
                if showing {
                    feedbackManager.soft()
                } else {
                    feedbackManager.medium()
                }
            }
        }
    }
}
