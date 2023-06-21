//
//  LocationListView.swift
//  Explorer
//
//  Created by Jack Devey on 19/06/2023.
//

import SwiftUI
import MapKit

struct LocationListView: View {
    
    var location: MKMapItem
    
    var body: some View {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(categoryColor(category: location.pointOfInterestCategory).gradient)
#if os(iOS)
                        .frame(width: 40, height: 40)
#endif
#if os(macOS)
                        .frame(width: 30, height: 30)
#endif
                    Image(systemName: categoryIcon(category: location.pointOfInterestCategory))
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading) {
                    Text(location.name ?? "")
                        .lineLimit(1)
                        .bold()
                    Text(location.placemark.title ?? "")
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding([.leading, .trailing], 5)
            }
        }
    
}

func categoryColor(category: MKPointOfInterestCategory?) -> Color {
    switch(category) {
    case MKPointOfInterestCategory.restaurant:
        return .orange
    case MKPointOfInterestCategory.cafe:
        return .yellow
    default:
        return .gray
    }
}

func categoryIcon(category: MKPointOfInterestCategory?) -> String {
    switch(category) {
    case MKPointOfInterestCategory.restaurant:
        return "fork.knife"
    case MKPointOfInterestCategory.cafe:
        return "cup.and.saucer.fill"
    default:
        return "questionmark"
    }
}
