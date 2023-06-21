import SwiftUI
import MapKit
import CoreLocation

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @Published var searchResults: [MKMapItem] = []

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        let authorised = status == .authorizedAlways
        
        if authorised {
            manager.startUpdatingLocation()
        }
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Food and Drink"
        request.region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            DispatchQueue.main.async {
                self.searchResults = response.mapItems
            }
        }

        manager.stopUpdatingLocation()
    }
}

struct ContentView: View {
    @StateObject private var locationDelegate = LocationDelegate()
        
    @State private var types: [ListType] = [ListType(icon: "fork.knife.circle", name: "Food & Drink", searchTerm: "Food & Drink")]
    @State private var type: ListType?
    
    
    @State private var location: MKMapItem?
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
            NavigationSplitView {
                List(types, selection: $type) { type in
                    Label(type.name, systemImage: type.icon).tag(type)
                }
                .navigationTitle("Category")
#if os(iOS)
                .navigationBarTitleDisplayMode(.large)
#endif
                
            } content: {
                if (type != nil) {
                    ScrollViewReader { content in
                        List(locationDelegate.searchResults, id: \.self, selection: $location) { result in
                            LocationListView(location: result).tag(result)
                        }
                        .navigationTitle(type?.name ?? "")
#if os(iOS)
                        .listStyle(.insetGrouped)
                        .navigationBarTitleDisplayMode(.large)
#endif
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    location = locationDelegate.searchResults.randomElement()
                                    content.scrollTo(location)
                                } label: {
                                    Label("Random", systemImage: "dice")
                                }
                            }
                        }
                    }
                }
            } detail: {
                if let location = location {
                    VStack(spacing: 15) {
                        HStack(alignment: .center) {
                            // Cheaply re-use the location list view
                            LocationListView(location: location)
                            Spacer()
                            // Open in Maps button
                            Button {
                                location.openInMaps()
                            } label: {
                                Label("Open in Maps", systemImage: "location.fill")
                            }
#if os(macOS)
                            .buttonStyle(.link)
#endif
                        }
                        
                        Map(position: $position, bounds: MapCameraBounds(minimumDistance: 100.0)) {
                            Marker(location.name ?? "", coordinate: location.placemark.coordinate)
                                .tint(categoryColor(category: location.pointOfInterestCategory))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
#if os(macOS)
                        .mapControls {
                            MapZoomStepper()
                        }
                        .frame(height: 350)
#endif
#if os(iOS)
                        .frame(height: 200)
#endif
                        .onChange(of: location) {
                            position = .automatic
                        }
                        
                        Spacer()
                        Text("ho")
                    }
                    .padding()
                }
            }
    }
    
    private func region(for mapItem: MKMapItem) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        return MKCoordinateRegion(center: mapItem.placemark.coordinate, span: span)
    }
}
