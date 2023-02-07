//
//  UserLocationViews.swift
//  UberClone
//
//  Created by Hendrik Steen on 12.10.22.
//


//TODO: More customizations on views

import SwiftUI
import MapKit

struct UserLocationViews: View {
    @StateObject var lvm = LocationViewModel()
    @StateObject var avm = ApplicationViewModel()
    var body: some View {
        switch lvm.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(lvm)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            TrackingView()
                .environmentObject(lvm)
                .environmentObject(avm)
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var lvm: LocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                lvm.requestPermission()
            }, label: {
                Label("Allow tracking", systemImage: "location")
            })
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("We need your permission to track you.")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                    .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.red)
    }
}

struct TrackingView: View {
    @EnvironmentObject var lvm: LocationViewModel
    @EnvironmentObject var avm: ApplicationViewModel
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var mapAnnotations: [CustomMapAnnotation] = []
    
    @State private var showDrivingView: Bool = false
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: mapAnnotations) { annotation in
                //TODO: This MapAnnotation view causes a purple error. I could use MapMarker instead but I need to use MapAnnotation for this usecase.
                MapAnnotation(coordinate: annotation.location.coordinate) {
                    Button {
                        withAnimation() {
                            avm.currentPossibleDriver = annotation.possibleDriver!
                        }
                    } label: {
                        VStack(spacing: 0) {
                            Image(systemName: annotation.systemImage)
                                .font(.title)
                                .foregroundColor(annotation.imageColor)
                              
                              Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption)
                                .foregroundColor(annotation.imageColor)
                                .offset(x: 0, y: -5)
                            }
                    }.disabled(annotation.isDestination == true)
                }

            }
            .onChange(of: avm.mapAnnotations) { newValue in
                mapAnnotations = newValue
            }
            
            BottomSheet()
                .onAppear() {
                    if let userLocation = lvm.getUserLocation() {
                        region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    }
                }
                .environmentObject(lvm)
                .environmentObject(avm)
               .ignoresSafeArea(.all, edges: .bottom)
            
            VStack {
                Button {
                    showDrivingView.toggle()
                } label: {
                    Text("Show driving view")
                }

                Spacer()
            }
            
        }
        .sheet(isPresented: $showDrivingView) {
            DrivingView(applicationViewModel: avm, showDrivingSheet: $showDrivingView)
        }
    }
}




