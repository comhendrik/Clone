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
    @State private var possiblesDrives: [PossibleDrive] = []
    @State private var cachedDrives: [PossibleDrive] = []
    @StateObject var accountViewModel: AccountViewModel
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54.6709, longitude: 8.77388), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var possibleDriveInformation: PossibleDrive?
    @State private var showMoreInformation = false
    @State private var showDrivingSheet = false
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
                            cachedDrives = possiblesDrives
                            possiblesDrives = [drive, PossibleDrive(id: "0", userLocation: drive.userDestination, userDestination: drive.userDestination, price: drive.price, isDestinationAnnotation: true, driveStatus: drive.driveStatus)]
                        } label: {
                            Image(systemName: "person")
                        }
                    }

                }
            }
            .onChange(of: accountViewModel.possibleDrives) { newValue in
                possiblesDrives = newValue
            }
            VStack {
                HStack {
                    Spacer()
                    Button {
                        Task {
                            await accountViewModel.loadPossibleDrives()
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(showMoreInformation ? .gray : .blue)
                    }
                    .disabled(showMoreInformation)
                    
                }
                Spacer()
                
                Button {
                    showDrivingSheet.toggle()
                } label: {
                    Text("Driving Information")
                }
            }
            .padding()
            .sheet(isPresented: $showDrivingSheet) {
                DrivingView(accountViewModel: accountViewModel, showDrivingSheet: $showDrivingSheet)
            }
            
            if showMoreInformation {
                VStack {
                    Spacer()
                    PossibleDriveInformationView(possibleDrive: possibleDriveInformation, acceptAction: {
                        accountViewModel.acceptDrive(drive: possibleDriveInformation)
                    }, action: {
                        withAnimation() {
                            showMoreInformation = false
                        }
                        possibleDriveInformation = nil
                        possiblesDrives = cachedDrives
                        cachedDrives = []
                    })
                }
                .padding(.bottom)
            }
        }
    }
}

struct PossibleDriveInformationView: View {
    var possibleDrive: PossibleDrive?
    let acceptAction: () -> Void
    let action: () -> Void
    var body: some View {
        VStack {
            if possibleDrive != nil {
                Text(possibleDrive!.id)
                Text("\(possibleDrive!.price, specifier: "%.2f")")
                Button {
                    acceptAction()
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

