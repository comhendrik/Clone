//
//  PossibleDrivesView.swift
//  Driver
//
//  Created by Hendrik Steen on 09.01.23.
//

import SwiftUI
import CoreLocation
import MapKit

//coding with dummy data

struct PossibleDrivesView: View {
    @State private var possiblesDrives = [PossibleDrive(id: "1", userLocation: CLLocation(latitude: 54.7709, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 34.99, isDestinationAnnotation: false),PossibleDrive(id: "2", userLocation: CLLocation(latitude: 54.6709, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 15.99, isDestinationAnnotation: false),PossibleDrive(id: "3", userLocation: CLLocation(latitude: 54.7909, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 29.99, isDestinationAnnotation: false)]
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54.6709, longitude: 8.77388), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var possibleDriveInformation: PossibleDrive?
    @State private var showMoreInformation = false
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: possiblesDrives) { drive in
                MapAnnotation(coordinate: drive.userLocation.coordinate) {
                    if drive.isDestinationAnnotation {
                        Image(systemName: "pin")
                    } else {
                        Button {
                            possibleDriveInformation = drive
                            withAnimation() {
                                showMoreInformation = true
                            }
                            possiblesDrives = [drive, PossibleDrive(id: "0", userLocation: drive.userDestination, userDestination: drive.userDestination, price: drive.price, isDestinationAnnotation: true)]
                        } label: {
                            Image(systemName: "person")
                        }
                    }

                }
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        possiblesDrives = [PossibleDrive(id: "1", userLocation: CLLocation(latitude: 54.7709, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 34.99, isDestinationAnnotation: false),PossibleDrive(id: "2", userLocation: CLLocation(latitude: 54.6709, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 15.99, isDestinationAnnotation: false),PossibleDrive(id: "3", userLocation: CLLocation(latitude: 54.7909, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 29.99, isDestinationAnnotation: false)]
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(showMoreInformation ? .gray : .blue)
                    }
                    .disabled(showMoreInformation)

                }
                Spacer()
            }
            .padding()
            
            if showMoreInformation {
                VStack {
                    Spacer()
                    PossibleDriveInformationView(possibleDrive: possibleDriveInformation) {
                        withAnimation() {
                            showMoreInformation = false
                        }
                        possibleDriveInformation = nil
                        possiblesDrives = [PossibleDrive(id: "1", userLocation: CLLocation(latitude: 54.7709, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 34.99, isDestinationAnnotation: false),PossibleDrive(id: "2", userLocation: CLLocation(latitude: 54.6709, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 15.99, isDestinationAnnotation: false),PossibleDrive(id: "3", userLocation: CLLocation(latitude: 54.7909, longitude: 8.77388), userDestination: CLLocation(latitude: 54.474705, longitude: 9.048684), price: 29.99, isDestinationAnnotation: false)]
                    }
                }
                .padding(.bottom)
            }
        }
    }
}

struct PossibleDriveInformationView: View {
    var possibleDrive: PossibleDrive?
    let action: () -> Void
    var body: some View {
        VStack {
            if possibleDrive != nil {
                Text(possibleDrive!.id)
                Text("\(possibleDrive!.price, specifier: "%.2f")")
                Button {
                    print("starting driving...")
                } label: {
                    Text("Accept drive")
                }
            } else {
                Text("Problems with drive")
            }
            Button {
                action()
            } label: {
                Text("Close")
            }

        }
        .frame(width: UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 10))
        .padding()
        .background(Color.white.cornerRadius(25))
    }
}

struct PossibleDrivesView_Previews: PreviewProvider {
    static var previews: some View {
        PossibleDrivesView()
    }
}
