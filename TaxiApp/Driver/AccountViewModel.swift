//
//  AccountViewModel.swift
//  Driver
//
//  Created by Hendrik Steen on 26.11.22.
//

import SwiftUI
import Foundation
import FirebaseAuth


//TODO: Error handling in interaction between driver and user. Now a user can cancel a drive and when the driver haven't refreshed he can still change states, although the user dont need the drive anymore: func updateDriveStatus()
class AccountViewModel: ObservableObject {
    @Published var user: DriverAccount? = nil
    @Published var possibleDrives: [Drive] = []
    
    @Published var actualDrive: Drive? = nil
    
    @Published var showAlert: Bool = false
    @Published var alertMsg: String = "No msg"
    
    @Published var isWorking: Bool = false
    //Normal Strings are used because we check on the updateDrivingData() function wether it is a double or not
    @Published var changePricePerArrivingKM = ""
    @Published var changePricePerKM = ""
    
    
    func loadDriver() {
        //DispatchQueue because otherwise the UI will be updated on a background thread
        if let currentUser = Auth.auth().currentUser {
            DispatchQueue.main.async {
                Task {
                    self.user = await DriverAccount(id: currentUser.uid)
                    if self.user != nil {
                        await self.loadPossibleDrives()
                        self.isWorking = self.user!.isWorking
                    }
                }
            }
        }
        
    }
    
    func acceptDrive(drive: Drive?) {
        if drive == nil {
            print("error")
            return
        }
        if user != nil {
            drive?.assignDriver(driverID: user!.id)
            actualDrive = drive
            actualDrive?.driveStatus = .pending
        } else {
            print("error")
            actualDrive = nil
        }
    }
    
    func loadPossibleDrives() async {
        await MainActor.run {
            self.possibleDrives = []
        }
        if user != nil {
            let drives = await self.user!.fetchPossibleDrives()
            await MainActor.run {
                self.possibleDrives = drives
            }
        } else {
            alertMsg = "No current user. Please reload"
            showAlert.toggle()
        }
    }
    
    func getNewestInformationsForActualDrive() {
        Task {
            let newStatus =  await actualDrive!.getNewestInformation()
            await MainActor.run {
                actualDrive!.driveStatus = newStatus
            }
        }
    }
    
    func updateDriveStatus() -> Bool {
        if user == nil {
            print("error user is nil")
            return false
        }
        if actualDrive != nil {
            var driveStatusForChanging: DriveStatus? = nil
            let currentDriveStatus = actualDrive!.driveStatus
            if currentDriveStatus == .pending {
                driveStatusForChanging = .arriving
            } else if currentDriveStatus == .driving {
                driveStatusForChanging = .success
            }
            
            if driveStatusForChanging != nil {
                actualDrive!.updateDriveStatus(status: driveStatusForChanging!)
                getNewestInformationsForActualDrive()
            } else if currentDriveStatus == .success || currentDriveStatus == .cancelled{
                actualDrive!.setToFinished(driverID: user!.id)
                actualDrive = nil
                possibleDrives = []
                
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
    
    
    func updateDrivingData() {
        if user != nil {
            DispatchQueue.main.async {
                Task {
                    self.alertMsg = await self.user!.updateDrivingData(id: self.user!.id, isWorking: self.isWorking, pricePerArrivingKM: self.changePricePerArrivingKM, pricePerKM: self.changePricePerKM)
                    self.showAlert.toggle()
                }
            }
        } else {
            alertMsg = "No current user. Please reload"
            showAlert.toggle()
        }
        
    }
}

