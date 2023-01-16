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
    
    @Published var currentDrive: Drive? = nil
    
    @Published var currentDriveID: String? = nil
    
    @Published var driveState: DriveStatus = .notBooked
    
    @Published var mapAnnotations: [CustomMapAnnotation] = []
    
    @Published var alertMsg: String = ""
    
    @Published var showAlert: Bool = false
    
    
    func bookDrive() {
        if currentDrive != nil {
            let res = currentDrive!.bookDrive()
            driveState = res.0
            currentDriveID = res.1
        } else {
            print("no current drive to book")
        }
    }
    
    func getNewestInformation() {
        if currentDrive != nil {
            if currentDriveID != nil {
                Task {
                    let currentStatus = await currentDrive!.getNewestInformation(id: currentDriveID!)
                    await MainActor.run {
                        driveState = currentStatus
                    }
                }
            } else {
                print("no currentDrive to check status")
            }
        } else {
            print("no current drive to book")
        }
    }
    
    func updateDrive(with status: DriveStatus) {
        if currentDrive != nil {
            if currentDriveID != nil {
                currentDrive!.updateStatus(id: currentDriveID!, status: status)
            } else {
                print("no currentDrive to update status")
            }
        } else {
            print("no current drive to update")
        }
    }
    
    
    func setDrive(with drive: Drive) {
        currentDrive = drive
    }
    //TODO: deleteDrive function needed to be updated
    func deleteDrive(afterBooking: Bool) {
        
        if afterBooking {
            //Send some data to the driver
        }
        updateDrive(with: .success)
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
                        mapAnnotations.append(CustomMapAnnotation(location: option.driver.location, type: .drive, drive: option))
                    }
                    
                    mapAnnotations.append(CustomMapAnnotation(location: endLocation!, type: .destination))
                }
                
                
                
                
                return "Your Drive options are shown on the map."
            }
        }
    }
    
}
