import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @EnvironmentObject private var locationDelegate: LocationDelegate
            
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
                    
                    // Top categories
                    
                    HorizontalListView(
                        defaultCategories,
                        title: "Top Categories",
                        subtitle: "Popular right now"
                    ) { category in
                        
                        NavigationLink {
                            ListTypeView(path: $path, type: category)
                                .onAppear {
                                    locationDelegate.startUpdatingLocation(for: category)
                                }
                        } label: {
                            ZStack {
                                // Cool background image
                                Image(category.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 11))
                                
                                // The text and icons
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading) {
                                        Image(systemName: category.icon)
                                            .imageScale(.large)
                                        Spacer()
                                        Text(category.name)
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
                    
                    HorizontalScrollingGridView(
                        MKPointOfInterestCategory.allCases,
                        title: "Location Types",
                        subtitle: "DONT WORRY WILL DELETE"
                    ) { poiCategory in
                        HStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(categoryIconColourPair(category: poiCategory).1.gradient)
                                    .frame(width: 35, height: 35)
                                Image(systemName: categoryIconColourPair(category: poiCategory).0)
                                    .foregroundStyle(.white)
                            }
                            VStack(alignment: .leading) {
                                Text(poiCategory.name)
                                    .lineLimit(1)
                                    .bold()
                                
                            }
                            .padding([.leading, .trailing], 5)
                            Spacer()
                        }
                    }
           
//                    VStack(alignment: .leading) { // Your original VStack
//                        ForEach(defaultCategories) { type in
//                            NavigationLink(value: type) {
//                                HStack {
//                                    ZStack {
//                                        RoundedRectangle(cornerRadius: 8)
//                                            .fill(type.color.gradient)
//                                            .frame(width: 40, height: 40)
//                                        Image(systemName: type.icon)
//                                            .foregroundStyle(.white)
//                                    }
//                                    VStack(alignment: .leading) {
//                                        Text(type.name)
//                                            .lineLimit(1)
//                                            .bold()
//                                        Text(type.icon)
//                                            .foregroundStyle(.secondary)
//                                            .lineLimit(1)
//                                    }
//                                    .padding([.leading, .trailing], 5)
//                                }
//                            }
//                            .padding(0)
//                            
//                            if type.name != defaultCategories.last?.name {
//                                Divider()
//                                    .padding([.vertical], 5)
//                            }
//                        }
//                    }
//                    .padding() // Add some padding to the whole view

                    
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
            
            .navigationDestination(for: MKMapItem.self) { location in
                LocationDetailView(location: location)
            }
        }
    }
    
    private func region(for mapItem: MKMapItem) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        return MKCoordinateRegion(center: mapItem.placemark.coordinate, span: span)
    }
}
