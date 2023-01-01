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
