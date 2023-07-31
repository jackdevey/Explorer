import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
    @StateObject private var locationDelegate = LocationDelegate()
        
    @State private var type: Category?
    
    
    @State private var location: MKMapItem?
    @State private var position: MapCameraPosition = .automatic
    @State private var isLookingAround: Bool = false
    
    @State private var path = NavigationPath()
    
    @State private var diceRoll = false
    
    @State private var isShowingSettingsSheet = false
    @State private var isShowingExplorerPlusSubscriptionSheet = false
    @State private var isShowingCustomCategorySheet = false

    var body: some View {
        
        NavigationStack(path: $path) {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading) {
                    
                    VStack {
                        NavigationLink {
                            Grid {
                                Text("s")
                                Text("s")
                                Text("s")
                            }
                            .navigationTitle("Top Categories")
                            .navigationBarTitleDisplayMode(.inline)
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Top Categories")
                                        .foregroundStyle(Color.primary)
                                        .font(.title2)
                                        .bold()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.secondary)
                                        .bold()
                                }
                                Text("Popular right now")
                                    .foregroundStyle(Color.secondary)
                            }
                        }
                        
                    }
                    .padding([.horizontal], 20)
                    
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(defaultCategories) { type in
                                NavigationLink(value: type) {
                                    RoundedRectangle(cornerRadius: 11)
                                        .fill(type.color.gradient)
                                        .frame(width: 250, height: 150)
                                        .overlay {
                                            HStack(alignment: .bottom) {
                                                VStack(alignment: .leading) {
                                                    Image(systemName: type.icon)
                                                        .imageScale(.large)
                                                    Spacer()
                                                    Text(type.name)
                                                        .font(.title)
                                                        .lineLimit(1)
                                                        .bold()
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .foregroundStyle(.white)
                                        }
                                }
                            }
                        }
                        .scrollTargetLayout()
                        .padding([.horizontal], 20)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    
                    
           
                    VStack(alignment: .leading) { // Your original VStack
                        ForEach(defaultCategories) { type in
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
                            .padding(0)
                            
                            if type.name != defaultCategories.last?.name {
                                Divider()
                                    .padding([.vertical], 5)
                            }
                        }
                    }
                    .padding() // Add some padding to the whole view

                    
//                    List {
//                        ForEach(defaultCategories, id: \.self) { type in
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 8)
//                                    .fill(type.color.gradient)
//                                    .frame(width: 40, height: 40)
//                                Image(systemName: type.icon)
//                                    .foregroundStyle(.white)
//                            }
//                            VStack(alignment: .leading) {
//                                Text(type.name)
//                                    .lineLimit(1)
//                                    .bold()
//                                Text(type.icon)
//                                    .foregroundStyle(.secondary)
//                                    .lineLimit(1)
//                            }
//                        }
//                    }
//                    .scrollClipDisabled()
                    
                }
                
            }
            .navigationTitle(purchaseManager.isExplorerPlusSubscriber ? "Explorer+" : "Explorer")
            .onAppear {
                locationDelegate.requestLocationPermission()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        if purchaseManager.isExplorerPlusSubscriber {
                            
                        } else {
                            isShowingExplorerPlusSubscriptionSheet.toggle()
                        }
                    } label: {
                        Label("New", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button {
                        isShowingSettingsSheet.toggle()
                    } label: {
                        Label("Settings", systemImage: "gearshape")
                    }
                }
            }
            .sheet(isPresented: $isShowingSettingsSheet) {
                SettingsView()
            }
            .sheet(isPresented: $isShowingExplorerPlusSubscriptionSheet) {
                ExplorerPlusSubscriptionView()
            }
            
            .navigationDestination(for: Category.self) { type in
                ListTypeView(path: $path, type: type)
                    .environmentObject(locationDelegate)
                    .onAppear {
                        locationDelegate.startUpdatingLocation(for: type)
                    }
            }
            
            .navigationDestination(for: MKMapItem.self) { location in
                List {
                    Section {
                        Map(position: $position, bounds: MapCameraBounds(minimumDistance: 100.0)) {
                            Marker(location.name ?? "", coordinate: location.placemark.coordinate)
                                .tint(categoryIconColourPair(category: location.pointOfInterestCategory).1)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())
                        .frame(height: 250)
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
                    
                    if location.pointOfInterestCategory != nil {
                        Section {
                            ForEach(locationDelegate.findSimilarLocations(to: location), id: \.self) { location in
                                NavigationLink(value: location) {
                                    LocationListView(location: location)
                                }
                            }
                        } header: {
                            Text("Similar")
                        }
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
