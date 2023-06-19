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
                    switch location.pointOfInterestCategory {
                    case MKPointOfInterestCategory.restaurant:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.orange.gradient)
#if os(iOS)
                            .frame(width: 40, height: 40)
#endif
#if os(macOS)
                            .frame(width: 30, height: 30)
#endif
                        Image(systemName: "fork.knife")
                    case MKPointOfInterestCategory.cafe:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.yellow.gradient)
#if os(iOS)
                            .frame(width: 40, height: 40)
#endif
#if os(macOS)
                            .frame(width: 30, height: 30)
#endif
                        Image(systemName: "cup.and.saucer.fill")
                    default:
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.gray.gradient)
#if os(iOS)
                            .frame(width: 40, height: 40)
#endif
#if os(macOS)
                            .frame(width: 30, height: 30)
#endif
                        Image(systemName: "questionmark")
                    }
                    
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
