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
    
    @Published var driveIsBooked = false
    
    func setDrive(with drive: Drive) {
        currentDrive = drive
    }
    
    func deleteDrive() {
        currentDrive = nil
    }
}
