//
//  ApplicationViewModel.swift
//  UberClone
//
//  Created by Hendrik Steen on 15.10.22.
//

import Foundation
import SwiftUI
import CoreLocation

class ApplicationViewModel: ObservableObject {
    
    @Published var currentPossibleDriver: PossibleDriver? = nil
    
    @Published var driveState: DriveStatus = .notBooked
    
    @Published var mapAnnotations: [CustomMapAnnotation] = []
    
    @Published var alertMsg: String = ""
    
    @Published var showAlert: Bool = false
    
    @Published var currentDrive: Drive? = nil
    
    @AppStorage("currentDriveID") var currentDriveID: String = ""
    
    
    //TODO: error alert for all functions
    
    
    func fetchCurrentDrive() async {
        do {
            if currentDriveID != "" {
                let doc = try await db.collection("PossibleDrives").document(currentDriveID).getDocument()
                let docID = doc.documentID
                let userLatitude = doc.data()?["userLatitude"] as? Double ?? 0.0
                let userLongitude = doc.data()?["userLongitude"] as? Double ?? 0.0
                let destinationLatitude = doc.data()?["destinationLatitude"] as? Double ?? 0.0
                let destinationLongitude = doc.data()?["destinationLongitude"] as? Double ?? 0.0
                let price = doc.data()?["price"] as? Double ?? 0.0
                let driveStatus = doc.data()?["driveStatus"] as? Int ?? 0
                
                let encodedDriveStatus = intForDriveStatus(int: driveStatus)
                
                await MainActor.run {
                    currentDrive = Drive(id: docID, userLocation: CLLocation(latitude: userLatitude, longitude: userLongitude), userDestination: CLLocation(latitude: destinationLatitude, longitude: destinationLongitude), price: price, isDestinationAnnotation: false, driveStatus: encodedDriveStatus)
                }
            } else {
                print("no current drive")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    init() {
        if currentDriveID != "" {
            Task {
                await fetchCurrentDrive()
            }
        }
    }
    
    func bookDrive() {
        if currentPossibleDriver != nil {
            let res = currentPossibleDriver!.bookDrive()
            driveState = res.0
            currentDriveID = res.1
            Task {
                await fetchCurrentDrive()
            }
        } else {
            print("no current drive to book")
        }
    }
    
    func getNewestInformations() {
        
        Task {
            if currentDrive == nil {
                print("error")
                return
            }
            let newStatus =  await currentDrive!.getNewestInformation()
            await MainActor.run {
                currentDrive!.driveStatus = newStatus
            }
        }
    }
    
    
    func updateDriveStatus() -> Bool {
        if currentDrive != nil {
            if currentDrive!.driveStatus == .arriving {
                currentDrive!.updateDriveStatus(status: .driving)
                currentDrive!.driveStatus = .driving
                getNewestInformations()
            } else if currentDrive!.driveStatus == .success {
                deleteDrive(afterBooking: false)
                return true
            } else {
                print("no update check reason")
                return false
            }
                        
        } else {
            print("error")
            return false
        }
        
        return false
    }
    
    
    func setDrive(with drive: Drive) {
        currentDrive = drive
    }
    
    
    func deleteDrive(afterBooking: Bool) {
        if currentDrive == nil {
            print("no current drive")
            return
        }
        if afterBooking {
            currentDrive!.updateDriveStatus(status: .cancelled)
        }
        
        currentPossibleDriver = nil
        currentDriveID = ""
        currentDrive = nil
        driveState = .notBooked
        
    }
    func setRouteLocations(userLocation: CLLocation?, end: String, ride: DrivingMode, radius: Int) async -> String {
        
        await MainActor.run {
            mapAnnotations = []
        }
        
        
        let endLocation = await getLocation(forPlaceCalled: end)
        
        let startLocation = userLocation
        
        if startLocation == nil {
            return "We can't detect a start location."
        } else if endLocation == nil {
            return "Be more precisely when describing your end location."
        } else {
            
            
            
            let rideRequest = RideRequest(drivingMode: ride, start: startLocation!, destination: endLocation!)
            let driveOptions = await rideRequest.sendRequest(radius: radius)
            if driveOptions.isEmpty {
                return "We haven't found any options. Try different Types or later again"
            } else {
                await MainActor.run {
                    for option in driveOptions {
                        mapAnnotations.append(CustomMapAnnotation(location: option.location, isDestination: false, possibleDriver: option))
                    }
                    
                    mapAnnotations.append(CustomMapAnnotation(location: endLocation!, isDestination: true))
                }
                
                
                
                
                return "Your Drive options are shown on the map."
            }
        }
    }
    
}
