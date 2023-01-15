//
//  AccountViewModel.swift
//  Driver
//
//  Created by Hendrik Steen on 26.11.22.
//

import SwiftUI
import Foundation
import FirebaseAuth

class AccountViewModel: ObservableObject {
    @Published var user: DriverAccount? = nil
    @Published var possibleDrives: [PossibleDrive] = []
    
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
    
    func loadPossibleDrives() async {
        if user != nil {
            let drives = await self.user!.fetchPossibleDrives(id: self.user!.id)
            await MainActor.run {
                self.possibleDrives = drives
            }
        } else {
            alertMsg = "No current user. Please reload"
            showAlert.toggle()
        }
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

