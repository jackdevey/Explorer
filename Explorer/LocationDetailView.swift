//
//  LocationDetailView.swift
//  Explorer
//
//  Created by Jack Devey on 01/08/2023.
//

import SwiftUI
import ScalingHeaderScrollView
import ScrollKit
import MapKit

struct LocationDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State
    private var offset = CGPoint.zero
    
    @State var location: MKMapItem
    
    @State private var mapImage: UIImage? = UIImage(named: "placeholderImage")
    
    @State
    private var visibleRatio = CGFloat.zero
    
    @State var backButtonHidden: Bool = true
    
    func handleOffset(_ scrollOffset: CGPoint, visibleHeaderRatio: CGFloat) {
        self.offset = scrollOffset
        self.visibleRatio = visibleHeaderRatio
    }
    
    func header() -> some View {
        ZStack {
            Rectangle()
                .fill(categoryIconColourPair(category: location.pointOfInterestCategory).1)
            
            HStack {
                Spacer()
                Image(systemName: categoryIconColourPair(category: location.pointOfInterestCategory).0)
                    .imageScale(.large)
                    .bold()
                Spacer()
            }
        }.opacity(visibleRatio)
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    ScrollViewHeader {
                        ZStack {
                            // Background tint
                            Rectangle()
                                .fill(categoryIconColourPair(category: location.pointOfInterestCategory).1.gradient)
                            
                            VStack(alignment: .leading) {
                                
                                // Centered icon
                                HStack {
                                    Spacer()
                                    Image(systemName: categoryIconColourPair(category: location.pointOfInterestCategory).0)
                                        .font(.largeTitle)
                                        .bold()
                                    Spacer()
                                }
                                .padding(.top, 300)
                                // Centered Title + Button
                                HStack {
                                    Spacer()
                                    VStack {
                                        Text(location.name ?? "Error")
                                            .font(.title).bold()
                                            .multilineTextAlignment(.center)
                                        Button {
                                            location.openInMaps()
                                        } label: {
                                            Label("Open in Maps", systemImage: "map.fill")
                                                .font(.headline)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .controlSize(.large)
                                        .tint(.white)
                                        .foregroundStyle(.black)
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }
                    
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                // Circle clipped back button
                ToolbarItem(placement: .navigation) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Label("Back", systemImage: "chevron.down")
                            .labelStyle(.iconOnly)
                            .bold()
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Circle())
                    .tint(.white)
                }
            }
        }
    }
}

//struct LocationDetailView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    @State private var isTopBarHidden = true
//    @State private var isLoading = false
//    
//    @State private var position: MapCameraPosition = .automatic
//    
//    @State var progress: CGFloat = 0
//    
//    @State var location: MKMapItem
//    
//    @State var backButtonHidden: Bool = true
//    
//    @State var headingOpacity: CGFloat = 1
//    
//    @State private var mapImage: UIImage? = UIImage(named: "placeholderImage")
//
//    var body: some View {
//        ZStack {
//            ScalingHeaderScrollView {
//                
////                Map(position: $position, bounds: MapCameraBounds(minimumDistance: 200.0)) {
////                    Marker(location.name ?? "", coordinate: location.placemark.coordinate)
////                        .tint(categoryIconColourPair(category: location.pointOfInterestCategory).1)
////                }
////                .mapControlVisibility(.hidden)
////                .opacity(1 - progress)
//                
//                ZStack {
//                    Rectangle()
//                        .fill(.gray.opacity(0.15))
//                    Image(uiImage: mapImage ?? UIImage(named: "placeholderImage")!) // Provide a placeholder image in case of failure
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .onAppear(perform: getMapImage)
//                }
//                
//            } content: {
//                LazyVStack {
//                    ForEach(0..<50, id: \.self) { _ in
//                        Text("↓ Pull to refresh ↓")
//                            .multilineTextAlignment(.center)
//                            .padding()
//                    }
//                }
//                
//            }
//            .height(min: 0.0)
//            .allowsHeader()
//            .collapseProgress($progress)
//            .onChange(of: progress) { old, new in
//                if new >= 0.75 && old < 0.75 {
//                    backButtonHidden = false
//                } else if new <= 0.75 && old > 0.75 {
//                    backButtonHidden = true
//                }
//            }
//            .navigationBarBackButtonHidden(backButtonHidden)
//            .ignoresSafeArea()
//            
//            topButtons
//        }
//    }
//    
//    func getMapImage() {
//            let options = MKMapSnapshotter.Options()
//            options.region = MKCoordinateRegion(center: location.placemark.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//            options.size = CGSize(width: 200, height: 200) // Adjust the size according to your needs
//
//            let snapshotter = MKMapSnapshotter(options: options)
//            snapshotter.start() { snapshot, error in
//                guard let snapshot = snapshot, error == nil else {
//                    print("Error generating map snapshot: \(error?.localizedDescription ?? "Unknown error")")
//                    return
//                }
//
//                mapImage = snapshot.image
//            }
//        }
//    
//    private var topButtons: some View {
//        VStack {
//            HStack(spacing: 16) {
//                // Circle clipped back button
//                Button {
//                    self.presentationMode.wrappedValue.dismiss()
//                } label: {
//                    Label("Back", systemImage: "chevron.left")
//                        .labelStyle(.iconOnly)
//                        .bold()
//                }
//                .buttonStyle(.bordered)
//                .clipShape(Circle())
//            
//                Spacer()
//                Button("", action: { print("Share") })
//                Button("", action: { print("Like") })
//            }
//            Spacer()
//        }
//        .padding(.top, 55)
//        .padding(.horizontal, 20)
//        .foregroundStyle(.white)
//        .ignoresSafeArea()
//    }
//}
