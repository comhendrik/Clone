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
    @StateObject var locationViewModel = LocationViewModel()
    @StateObject var applicationViewModel = ApplicationViewModel()
    var body: some View {
        switch locationViewModel.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView())
                .environmentObject(locationViewModel)
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            TrackingView()
                .environmentObject(locationViewModel)
                .environmentObject(applicationViewModel)
        default:
            Text("Unexpected status")
        }
    }
}

struct RequestLocationView: View {
    @EnvironmentObject var locationViewModel: LocationViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            Button(action: {
                locationViewModel.requestPermission()
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
    @EnvironmentObject var locationViewModel: LocationViewModel
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationViewModel.region, showsUserLocation: true, annotationItems: locationViewModel.driveOptions) { option in
                MapAnnotation(coordinate: option.driver.location.coordinate) {
                    Button {
                        applicationViewModel.currentDrive = option
                    } label: {
                        VStack(spacing: 0) {
                              Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundColor(.red)
                              
                              Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                                .offset(x: 0, y: -5)
                            }
                    }
                }

            }
            BottomSheet()
                .onAppear() {
                    locationViewModel.startLocation = locationViewModel.getUserLocation()
                }
                .environmentObject(locationViewModel)
                .environmentObject(applicationViewModel)
               .ignoresSafeArea(.all, edges: .bottom)
        }
    }
}
