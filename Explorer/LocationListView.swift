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
                        .fill(categoryIconColourPair(category: location.pointOfInterestCategory).1)
                        .frame(width: 40, height: 40)
                    Image(systemName: categoryIconColourPair(category: location.pointOfInterestCategory).0)
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

func categoryIconColourPair(category: MKPointOfInterestCategory?) -> (String, Color) {
    switch(category) {
        
    case MKPointOfInterestCategory.airport:
        return ("airplane.departure", .blue)
        
    case MKPointOfInterestCategory.amusementPark:
        return ("Star", .pink)
        
    case MKPointOfInterestCategory.aquarium:
        return ("fish.fill", .blue)
        
    case MKPointOfInterestCategory.atm:
        return ("sterlingsign.square", .green)
        
    case MKPointOfInterestCategory.bakery:
        return ("birthday.cake", .brown)
        
    case MKPointOfInterestCategory.bank:
        return ("building.columns.fill", .green)
        
    case MKPointOfInterestCategory.beach:
        return ("beach.umbrella.fill", .yellow)
        
    case MKPointOfInterestCategory.brewery:
        return ("wineglass", .brown)
        
    case MKPointOfInterestCategory.cafe:
        return ("cup.and.saucer.fill", .yellow)
        
    case MKPointOfInterestCategory.nationalPark:
        return ("mountain.2.fill", .green)
        
    case MKPointOfInterestCategory.park:
        return ("tree.fill", .green)
        
    case MKPointOfInterestCategory.store:
        return ("bag.fill", .purple)
        
    case MKPointOfInterestCategory.fitnessCenter:
        return ("figure.run", .teal)
        
    case MKPointOfInterestCategory.nightlife:
        return ("moon.stars.fill", .brown)
        
    case MKPointOfInterestCategory.movieTheater:
        return ("popcorn.fill", .red)
        
    case MKPointOfInterestCategory.restaurant:
        return ("fork.knife", .orange)
        
    default:
        return ("questionmark", .gray)
    }
}
