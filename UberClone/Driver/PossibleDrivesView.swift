//
//  PossibleDrivesView.swift
//  Driver
//
//  Created by Hendrik Steen on 13.02.23.
//
import SwiftUI
import CoreLocation
import MapKit

struct PossibleDrivesView: View {
    @State private var possiblesDrives: [Drive] = []
    @StateObject var accountViewModel: AccountViewModel
    @StateObject var loginViewModel: LoginViewModel
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 54.6709, longitude: 8.77388), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
    @State private var possibleDriveInformation: Drive?
    @State private var showMoreInformation = false
    @State private var showDrivingSheet = false
    @Binding var showUpdateProfileView: Bool
    @AppStorage("log_status") var status = false
    
    let buttonColor: Color = .blue
    let textButtonColor: Color = .white
    
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
                            .foregroundColor(buttonColor)
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
                            .foregroundColor(showMoreInformation ? .gray : buttonColor)
                    }
                    .disabled(showMoreInformation)
                    Button {
                        showUpdateProfileView.toggle()
                    } label: {
                        Image(systemName: "gear.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(buttonColor)
                    }
                    Button {
                        loginViewModel.logOut()
                        status = false
                    } label: {
                        Text("Sign Out")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(textButtonColor)
                            .padding(10)
                            .background(buttonColor)
                            .cornerRadius(20)
                    }

                    
                }
                Spacer()
                
                
            }
            .padding()
            .sheet(isPresented: $showDrivingSheet) {
                DrivingView(drive: accountViewModel.actualDrive) {
                    showDrivingSheet.toggle()
                    showMoreInformation = false
                } updateAction: {
                    if accountViewModel.updateDriveStatus() {
                        showDrivingSheet.toggle()
                        showMoreInformation.toggle()
                    }
                } refreshAction: {
                    accountViewModel.getNewestInformationsForActualDrive()
                }

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
