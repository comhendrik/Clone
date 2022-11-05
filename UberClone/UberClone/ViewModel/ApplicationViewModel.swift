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
    
    
    func setDrive(with drive: Drive) {
        currentDrive = drive
    }
    
    func deleteDrive(afterBooking: Bool) {
        currentDrive = nil
        driveState = .notBooked
        
        if afterBooking {
            //Send some data to the driver
        }
    }
    
    func stepIntoCar() {
        driveState = .driving
    }
    
}
