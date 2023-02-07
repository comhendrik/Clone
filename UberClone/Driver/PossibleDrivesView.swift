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
    @State private var possiblesDrives: [Drive] = []
    @StateObject var accountViewModel: AccountViewModel
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54.6709, longitude: 8.77388), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var possibleDriveInformation: Drive?
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
                            possiblesDrives = [drive, Drive(id: "0", userLocation: drive.userDestination, userDestination: drive.userDestination, price: drive.price, isDestinationAnnotation: true, driveStatus: drive.driveStatus)]
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
                    Button {
                        showDrivingSheet.toggle()
                    } label: {
                        Image(systemName: "car.circle.fill")
                            .font(.largeTitle)
                    }
                    Spacer()
                    Button {
                        self.possiblesDrives = []
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
                
                
            }
            .padding()
            .sheet(isPresented: $showDrivingSheet) {
                DrivingView(accountViewModel: accountViewModel, showDrivingSheet: $showDrivingSheet, showMoreInformation: $showMoreInformation)
            }
            
            if showMoreInformation {
                VStack {
                    Spacer()
                    PossibleDriveInformationView(possibleDrive: possibleDriveInformation, acceptAction: {
                        accountViewModel.acceptDrive(drive: possibleDriveInformation)
                        showDrivingSheet = true
                    }, closeAction: {
                        withAnimation() {
                            showMoreInformation = false
                        }
                        possibleDriveInformation = nil
                        Task {
                            await accountViewModel.loadPossibleDrives()
                        }
                    })
                }
                .padding(.bottom)
            }
        }
    }
}

struct PossibleDriveInformationView: View {
    var possibleDrive: Drive?
    let acceptAction: () -> Void
    let closeAction: () -> Void
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
                closeAction()
            } label: {
                Text("Close")
            }

        }
        .frame(width: UIScreen.main.bounds.width - (UIScreen.main.bounds.width / 10))
        .padding()
        .background(Color.white.cornerRadius(25))
    }
}

