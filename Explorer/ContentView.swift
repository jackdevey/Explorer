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
                            LocationListView(location: result).tag(result).id(result)
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
                                    withAnimation {
                                        content.scrollTo(location, anchor: .center)
                                    }
                                } label: {
                                    Label("Random", systemImage: "dice")
                                }
                            }
                        }
                    }
                }
            } detail: {
                if let location = location {
#if os(iOS)
                    List {
                        Section {
                            HStack(alignment: .center) {
                                // Cheaply re-use the location list view
                                LocationListView(location: location)
                                Spacer()
                                // Open in Maps button
                                //                                Button {
                                //                                    location.openInMaps()
                                //                                } label: {
                                //                                    Label("Open in Maps", systemImage: "location.fill")
                                //                                }
                            }
                            Map(position: $position, bounds: MapCameraBounds(minimumDistance: 100.0)) {
                                Marker(location.name ?? "", coordinate: location.placemark.coordinate)
                                    .tint(categoryColor(category: location.pointOfInterestCategory))
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .frame(height: 200)
                            .onChange(of: location) {
                                position = .automatic
                            }
                        } header: {
                            Text("Overview")
                        }
                        Section {
                            // Show phone number
                            if let phoneNumber = location.phoneNumber {
                                HStack {
                                    Text("Phone Number")
                                    Spacer()
                                    Text(phoneNumber)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            // Show URL
                            if let url = location.url {
                                HStack {
                                    Text("Website")
                                    Spacer()
                                    Link("Open Link", destination: url)
                                }
                            }
                        } header: {
                            Text("Details")
                        }
                    }
#endif
#if os(macOS)
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
                            .buttonStyle(.link)
                        }
                        
                        Map(position: $position, bounds: MapCameraBounds(minimumDistance: 100.0)) {
                            Marker(location.name ?? "", coordinate: location.placemark.coordinate)
                                .tint(categoryColor(category: location.pointOfInterestCategory))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .mapControls {
                            MapZoomStepper()
                        }
                        .frame(height: 350)
                        .onChange(of: location) {
                            position = .automatic
                        }
                        
                        // Show phone number
                        if let phoneNumber = location.phoneNumber {
                            HStack {
                                Text("Phone Number")
                                Spacer()
                                Text(phoneNumber)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        // Show URL
                        if let url = location.url {
                            HStack {
                                Text("Website")
                                Spacer()
                                Link("Open Link", destination: url)
                            }
                        }
                        Spacer()
                    }
                    .padding()
#endif
                }
            }
    }
    
    private func region(for mapItem: MKMapItem) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        return MKCoordinateRegion(center: mapItem.placemark.coordinate, span: span)
    }
}
