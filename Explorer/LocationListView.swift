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
    
    @State var isPresented: Bool = false
    
    var body: some View {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(categoryIconColourPair(category: location.pointOfInterestCategory).1.gradient)
                        .frame(width: 35, height: 35)
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
            .onTapGesture {
                isPresented.toggle()
            }
            .sheet(isPresented: $isPresented) {
                LocationDetailView(location: location)
            }
        }
    
}

func categoryIconColourPair(category: MKPointOfInterestCategory?) -> (String, Color) {
    switch(category) {
        
    case MKPointOfInterestCategory.airport:
        return ("airplane.departure", .blue)
        
    case MKPointOfInterestCategory.amusementPark:
        return ("star", .pink)
        
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
        
    case MKPointOfInterestCategory.campground:
        return ("campground", .green)
        
    case MKPointOfInterestCategory.carRental:
        return ("car.circle.fill", .purple)
        
    case MKPointOfInterestCategory.evCharger:
        return ("bolt.fill.batteryblock", .green)
        
    case MKPointOfInterestCategory.fireStation:
        return ("flame.fill", .red)
        
    case MKPointOfInterestCategory.fitnessCenter:
        return ("figure.run", .teal)
        
    case MKPointOfInterestCategory.foodMarket:
        return ("cart.fill", .orange)
        
    case MKPointOfInterestCategory.gasStation:
        return ("fuelpump.fill", .orange)
        
    case MKPointOfInterestCategory.hospital:
        return ("cross.fill", .red)
        
    case MKPointOfInterestCategory.hotel:
        return ("bed.double.fill", .red)
        
    case MKPointOfInterestCategory.laundry:
        return ("house.fill", .blue)
        
    case MKPointOfInterestCategory.library:
        return ("book.fill", .blue)
        
    case MKPointOfInterestCategory.marina:
        return ("boat.fill", .blue)
        
    case MKPointOfInterestCategory.movieTheater:
        return ("popcorn.fill", .red)
        
    case MKPointOfInterestCategory.museum:
        return ("museum.fill", .purple)
        
    case MKPointOfInterestCategory.nationalPark:
        return ("mountain.2.fill", .green)
        
    case MKPointOfInterestCategory.nightlife:
        return ("moon.stars.fill", .brown)
        
    case MKPointOfInterestCategory.park:
        return ("tree.fill", .green)
        
    case MKPointOfInterestCategory.parking:
        return ("car.fill", .blue)
        
    case MKPointOfInterestCategory.pharmacy:
        return ("cross.circle.fill", .green)
        
    case MKPointOfInterestCategory.police:
        return ("lock.fill", .blue)
        
    case MKPointOfInterestCategory.postOffice:
        return ("envelope.fill", .blue)
        
    case MKPointOfInterestCategory.publicTransport:
        return ("bus.fill", .purple)
        
    case MKPointOfInterestCategory.restaurant:
        return ("fork.knife", .orange)
        
    case MKPointOfInterestCategory.restroom:
        return ("wand.and.stars.inverse", .blue)
        
    case MKPointOfInterestCategory.school:
        return ("graduationcap.fill", .yellow)
        
    case MKPointOfInterestCategory.stadium:
        return ("sportscourt.fill", .blue)
        
    case MKPointOfInterestCategory.store:
        return ("bag.fill", .purple)
        
    case MKPointOfInterestCategory.theater:
        return ("ticket.fill", .red)
        
    case MKPointOfInterestCategory.university:
        return ("graduationcap.fill", .purple)
        
    case MKPointOfInterestCategory.winery:
        return ("winebottle.fill", .brown)
        
    case MKPointOfInterestCategory.zoo:
        return ("tortoise.fill", .green)
        
    default:
        return ("questionmark", .gray)
    }
}

extension MKPointOfInterestCategory: CaseIterable {
    public static var allCases: [MKPointOfInterestCategory] {
        return [
            .airport,
            .amusementPark,
            .aquarium,
            .atm,
            .bakery,
            .bank,
            .beach,
            .brewery,
            .cafe,
            .campground,
            .carRental,
            .evCharger,
            .fireStation,
            .fitnessCenter,
            .foodMarket,
            .gasStation,
            .hospital,
            .hotel,
            .laundry,
            .library,
            .marina,
            .movieTheater,
            .museum,
            .nationalPark,
            .nightlife,
            .park,
            .parking,
            .pharmacy,
            .police,
            .postOffice,
            .publicTransport,
            .restaurant,
            .restroom,
            .school,
            .stadium,
            .store,
            .theater,
            .university,
            .winery,
            .zoo
        ]
    }
}

extension MKPointOfInterestCategory: Identifiable {
    public var id: String {
        return rawValue
    }
}

extension MKPointOfInterestCategory {
    var name: String {
        switch self {
        case .airport: return "Airport"
        case .amusementPark: return "Amusement Park"
        case .aquarium: return "Aquarium"
        case .atm: return "ATM"
        case .bakery: return "Bakery"
        case .bank: return "Bank"
        case .beach: return "Beach"
        case .brewery: return "Brewery"
        case .cafe: return "Cafe"
        case .campground: return "Campground"
        case .carRental: return "Car Rental"
        case .evCharger: return "EV Charger"
        case .fireStation: return "Fire Station"
        case .fitnessCenter: return "Fitness Center"
        case .foodMarket: return "Food Market"
        case .gasStation: return "Gas Station"
        case .hospital: return "Hospital"
        case .hotel: return "Hotel"
        case .laundry: return "Laundry"
        case .library: return "Library"
        case .marina: return "Marina"
        case .movieTheater: return "Movie Theater"
        case .museum: return "Museum"
        case .nationalPark: return "National Park"
        case .nightlife: return "Nightlife"
        case .park: return "Park"
        case .parking: return "Parking"
        case .pharmacy: return "Pharmacy"
        case .police: return "Police"
        case .postOffice: return "Post Office"
        case .publicTransport: return "Public Transport"
        case .restaurant: return "Restaurant"
        case .restroom: return "Restroom"
        case .school: return "School"
        case .stadium: return "Stadium"
        case .store: return "Store"
        case .theater: return "Theater"
        case .university: return "University"
        case .winery: return "Winery"
        case .zoo: return "Zoo"
        default: return "Unknown"
        }
    }
}
