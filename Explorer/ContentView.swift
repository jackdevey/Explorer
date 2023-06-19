////
////  ContentView.swift
////  Explorer
////
////  Created by Jack Devey on 18/06/2023.
////
//
//import SwiftUI
//import SwiftData
//import MapKit
//import CoreLocation
//
//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//        .onAppear {
//            // Get the user's current location
//            let locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.requestWhenInUseAuthorization()
//            
//            let request = MKLocalSearch.Request()
//            request.naturalLanguageQuery = "restaurants"
//
//            if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedAlways {
//                if let userLocation = locationManager.location {
//                    request.region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
//                }
//            }
//            
//            
//            let search = MKLocalSearch(request: request)
//            search.start { (response, error) in
//                guard let response = response else {
//                    if let error = error {
//                        print("Error: \(error)")
//                    }
//                    return
//                }
//                
//                // Process the search results
//                for item in response.mapItems {
//                    print("Name: \(item.name ?? "")")
//                    print("Phone: \(item.phoneNumber ?? "")")
//                    print("Address: \(item.placemark.title ?? "")")
//                    print("Coordinates: \(item.placemark.coordinate.latitude), \(item.placemark.coordinate.longitude)")
//                    print("--------------------")
//                }
//            }
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}

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
    
    @State private var path = NavigationPath()
    
    @State private var types: [String] = ["Food & Drink"]
    @State private var type: String?
    
    @State private var location: MKMapItem?
    
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        NavigationSplitView() {
            
            List(types, id: \.self, selection: $type) { type in
                Text(type)
            }
            .navigationTitle("Category")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            
        } content: {
            if (type != nil) {
                List(locationDelegate.searchResults, id: \.self, selection: $location) { result in
                    LocationListView(location: result).tag(result)
                }
                .navigationTitle(type ?? "")
                #if os(iOS)
                .listStyle(.insetGrouped)
                .navigationBarTitleDisplayMode(.large)
                #endif
                .toolbar {
                    ToolbarItem {
                        Button {
                            location = locationDelegate.searchResults.randomElement()
                        } label: {
                            Label("Random", systemImage: "dice")
                        }
                    }
                }
            }
        } detail: {
            if let location = location {
                VStack(spacing: 15) {
                    HStack(alignment: .center) {
                        // Show a nice image
                        ZStack {
                            Circle()
                                .fill(.blue.gradient)
                                .frame(width: 25, height: 25)
                            Image(systemName: "airplane")
                        }
                        // Show name & address line
                        VStack(alignment: .leading) {
                            Text(location.name ?? "")
                                .font(.headline)
                                .lineLimit(1)
                            Text(location.placemark.title ?? "")
                                .font(.subheadline)
                                .lineLimit(1)
                        }
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
                            .tint(.orange)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    #if os(macOS)
                    .mapControls {
                        MapZoomStepper()
                    }
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

struct MapItemWrapper: Identifiable {
    let id = UUID()
    let mapItem: MKMapItem
}
