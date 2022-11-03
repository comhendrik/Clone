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
    
    func deleteDrive() {
        currentDrive = nil
        driveState = .notBooked
    }
    
    func stepIntoCar() {
        driveState = .success
    }
}
