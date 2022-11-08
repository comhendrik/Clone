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
    
    @Published var driveState: DriveStatus = .notBooked
    
    @Published var mapAnnotations: [CustomMapAnnotation] = []
    
    @Published var alertMsg: String = ""
    
    @Published var showAlert: Bool = false
    
    
    func setDrive(with drive: Drive) {
        currentDrive = drive
    }
    
    func deleteDrive(afterBooking: Bool) {
        
        if afterBooking {
            //Send some data to the driver
        }
        
        currentDrive = nil
        driveState = .notBooked
    }
    
    func stepIntoCar() {
        driveState = .driving
    }
    
    func setRouteLocations(userLocation: CLLocation?, end: String, ride: DrivingMode, radius: Int) async {
        
        mapAnnotations = []
        
        let endLocation = await getLocation(forPlaceCalled: end)
        
        let startLocation = userLocation
        
        if startLocation == nil {
            await MainActor.run {
                alertMsg = "We can't detect a start location."
                showAlert = true
            }
        } else if endLocation == nil {
            await MainActor.run {
                alertMsg = "Be more precisely when describing your end location."
                showAlert = true
            }
        } else {
            let rideRequest = RideRequest(drivingMode: ride, start: startLocation!, destination: endLocation!)
            let driveOptions = await rideRequest.sendRequest(radius: radius)
            
            await MainActor.run {
                
                
                
                if driveOptions.isEmpty {
                    alertMsg = "We haven't found any options. Try different Types or later again"
                } else {
                    for option in driveOptions {
                        mapAnnotations.append(CustomMapAnnotation(location: option.driver.location, type: .drive, drive: option))
                    }
                    
                    mapAnnotations.append(CustomMapAnnotation(location: endLocation!, type: .destination))
                    
                    alertMsg = "Your Drive options are shown on the map."
                }
                showAlert.toggle()
            }
        }
    }
    
}
