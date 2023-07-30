import Foundation
import CoreLocation
import MapKit
import Combine
import SwiftUI

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
        
    let locationManager = CLLocationManager()
    @Published var searchResults: [MKMapItem] = []
    
    @Published var state: LoadableState = .idle
    @Published var type: ListType?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation(for type: ListType) {
        
        if self.type == type {
            self.state = .loaded
        } else {
            self.type = type
            self.locationManager.startUpdatingLocation()
            self.searchResults = []
            self.state = .loading
        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let authorised = status == .authorizedAlways
        if authorised {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        
        if let selectedCategory = type {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = selectedCategory.searchTerm
            request.region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.searchResults = response.mapItems.sorted { first, second in
                        first.pointOfInterestCategory != nil
                    }
                    self.state = .loaded
                }
            }
        }
        
        manager.stopUpdatingLocation()
    }
}

enum LoadableState {
    case idle, loading, failed, loaded
}
