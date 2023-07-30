import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    @StateObject private var locationDelegate = LocationDelegate()
        
    @State private var types: [ListType] = [
        ListType(icon: "fork.knife", name: "Food & Drink", searchTerm: "Food & Drink", color: .orange),
        ListType(icon: "star.fill", name: "Entertainment", searchTerm: "Entertainment", color: .red)
    ]
    @State private var type: ListType?
    
    
    @State private var location: MKMapItem?
    @State private var position: MapCameraPosition = .automatic
    @State private var isLookingAround: Bool = false
    
    @State private var path = NavigationPath()

    var body: some View {
        
        
        NavigationStack(path: $path) {
            List {
                Section {
                    ForEach(types) { type in
                        NavigationLink(value: type) {
                            HStack {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(type.color.gradient)
                                        .frame(width: 40, height: 40)
                                    Image(systemName: type.icon)
                                        .foregroundStyle(.white)
                                }
                                VStack(alignment: .leading) {
                                    Text(type.name)
                                        .lineLimit(1)
                                        .bold()
                                    Text(type.icon)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                                .padding([.leading, .trailing], 5)
                            }
                        }
                    }
                } header: {
                    Text("Categories")
                }
            }
            .navigationTitle("Explorer")
            .onAppear {
                locationDelegate.requestLocationPermission()
            }
            
            .navigationDestination(for: ListType.self) { type in
                ListTypeView(path: $path, type: type)
                    .environmentObject(locationDelegate)
                    .onAppear {
                        locationDelegate.startUpdatingLocation(for: type)
                    }
            }
            
            .navigationDestination(for: MKMapItem.self) { location in
                List {
                    Section {
                        HStack(alignment: .center) {
                            // Cheaply re-use the location list view
                            LocationListView(location: location)
                            Spacer()
                        }
                        Map(position: $position, bounds: MapCameraBounds(minimumDistance: 100.0)) {
                            Marker(location.name ?? "", coordinate: location.placemark.coordinate)
                                .tint(categoryIconColourPair(category: location.pointOfInterestCategory).1)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .frame(height: 200)
                        .onChange(of: location) {
                            position = .automatic
                        }
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
                .navigationTitle(location.name ?? "Error")
                .lookAroundViewer(isPresented: $isLookingAround, initialScene: nil)
                .toolbar {
                    
                    ToolbarItem {
                        // Open in Maps button
                        Button {
                            isLookingAround = true
                        } label: {
                            Label("Look around", systemImage: "binoculars")
                        }
                    }
                    
                    ToolbarItem {
                        // Open in Maps button
                        Button {
                            location.openInMaps()
                        } label: {
                            Label("Open in Maps", systemImage: "location")
                        }
                    }
                    
                    ToolbarItem {
                        Button {
                            withAnimation {
                                path.removeLast()
                                path.append(locationDelegate.searchResults.randomElement()!)
                            }
                        } label: {
                            Label("Random", systemImage: "dice")
                        }
                    }
                }
            }
        }
    }
    
    private func region(for mapItem: MKMapItem) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        return MKCoordinateRegion(center: mapItem.placemark.coordinate, span: span)
    }
}
