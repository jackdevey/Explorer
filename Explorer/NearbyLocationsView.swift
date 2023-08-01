//
//  NearbyLocationsView.swift
//  Explorer
//
//  Created by Jack Devey on 01/08/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct NearbyLocationsView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var nearbyLocations: [MKMapItem] = []

    var body: some View {
        if nearbyLocations.count >= 8 {
            HorizontalScrollingGridView(
                nearbyLocations,
                title: "Nearby"
            ) { result in
                NavigationLink(value: result) {
                    LocationListView(location: result)
                }
            }
        } else {
            Text("s")
                .onReceive(locationManager.$userLocation) { location in
                    if let location = location {
                        fetchNearbyLocations(userLocation: location)
                    }
                }
        }
    }

    private func fetchNearbyLocations(userLocation: CLLocation) {

        // Define the search request with the user's location
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = "Point of Interest"
        searchRequest.region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        // Perform the search using MKLocalSearch
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { response, error in
            if let items = response?.mapItems {
                self.nearbyLocations = items
            }
        }
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var userLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location
        }
    }
}
