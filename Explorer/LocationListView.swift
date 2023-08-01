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
    
    @EnvironmentObject var feedbackManager: FeedbackManager
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            HStack(alignment: .center) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(categoryIconColourPair(category: location.pointOfInterestCategory).1)
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
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .tint(.primary)
        }
        .sheet(isPresented: $isPresented) {
            LocationDetailView(isPresented: $isPresented, location: location)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: isPresented) { hidden, showing in
            if showing {
                feedbackManager.soft()
            } else {
                feedbackManager.medium()
            }
        }
    }
}

func categoryIconColourPair(category: MKPointOfInterestCategory?) -> (String, Color) {
    switch(category) {
        
    case MKPointOfInterestCategory.airport:
        return ("airplane.departure", .customBlue)
        
    case MKPointOfInterestCategory.amusementPark:
        return ("star.fill", .customPink)
        
    case MKPointOfInterestCategory.aquarium:
        return ("fish.fill", .customBlue)
        
    case MKPointOfInterestCategory.atm:
        return ("sterlingsign.square", .customGreen)
        
    case MKPointOfInterestCategory.bakery:
        return ("birthday.cake", .brown)
        
    case MKPointOfInterestCategory.bank:
        return ("building.columns.fill", .customGreen)
        
    case MKPointOfInterestCategory.beach:
        return ("beach.umbrella.fill", .customYellow)
        
    case MKPointOfInterestCategory.brewery:
        return ("wineglass", .brown)
        
    case MKPointOfInterestCategory.cafe:
        return ("cup.and.saucer.fill", .customYellow)
        
    case MKPointOfInterestCategory.campground:
        return ("campground", .customGreen)
        
    case MKPointOfInterestCategory.carRental:
        return ("car.circle.fill", .customPurple)
        
    case MKPointOfInterestCategory.evCharger:
        return ("bolt.fill.batteryblock", .customGreen)
        
    case MKPointOfInterestCategory.fireStation:
        return ("flame.fill", .customRed)
        
    case MKPointOfInterestCategory.fitnessCenter:
        return ("figure.run", .customBlue)
        
    case MKPointOfInterestCategory.foodMarket:
        return ("cart.fill", .customOrange)
        
    case MKPointOfInterestCategory.gasStation:
        return ("fuelpump.fill", .customOrange)
        
    case MKPointOfInterestCategory.hospital:
        return ("cross.fill", .customRed)
        
    case MKPointOfInterestCategory.hotel:
        return ("bed.double.fill", .customPurple)
        
    case MKPointOfInterestCategory.laundry:
        return ("house.fill", .customBlue)
        
    case MKPointOfInterestCategory.library:
        return ("book.fill", .customBlue)
        
    case MKPointOfInterestCategory.marina:
        return ("boat.fill", .customBlue)
        
    case MKPointOfInterestCategory.movieTheater:
        return ("popcorn.fill", .customRed)
        
    case MKPointOfInterestCategory.museum:
        return ("museum.fill", .customPurple)
        
    case MKPointOfInterestCategory.nationalPark:
        return ("mountain.2.fill", .customGreen)
        
    case MKPointOfInterestCategory.nightlife:
        return ("moon.stars.fill", .brown)
        
    case MKPointOfInterestCategory.park:
        return ("tree.fill", .customGreen)
        
    case MKPointOfInterestCategory.parking:
        return ("car.fill", .customBlue)
        
    case MKPointOfInterestCategory.pharmacy:
        return ("cross.circle.fill", .customGreen)
        
    case MKPointOfInterestCategory.police:
        return ("lock.fill", .customBlue)
        
    case MKPointOfInterestCategory.postOffice:
        return ("envelope.fill", .customBlue)
        
    case MKPointOfInterestCategory.publicTransport:
        return ("bus.fill", .customPurple)
        
    case MKPointOfInterestCategory.restaurant:
        return ("fork.knife", .customOrange)
        
    case MKPointOfInterestCategory.restroom:
        return ("wand.and.stars.inverse", .customBlue)
        
    case MKPointOfInterestCategory.school:
        return ("graduationcap.fill", .customYellow)
        
    case MKPointOfInterestCategory.stadium:
        return ("sportscourt.fill", .customBlue)
        
    case MKPointOfInterestCategory.store:
        return ("bag.fill", .customPurple)
        
    case MKPointOfInterestCategory.theater:
        return ("ticket.fill", .customRed)
        
    case MKPointOfInterestCategory.university:
        return ("graduationcap.fill", .customPurple)
        
    case MKPointOfInterestCategory.winery:
        return ("winebottle.fill", .brown)
        
    case MKPointOfInterestCategory.zoo:
        return ("tortoise.fill", .customGreen)
        
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
