//
//  AccountViewModel.swift
//  Driver
//
//  Created by Hendrik Steen on 26.11.22.
//

import SwiftUI
import Foundation

class AccountViewModel: ObservableObject {
    @Published var user: DriverAccount? = nil
    
    @Published var isWorking: Bool = false
    //TODO: Using integers for text fields
    @Published var changePricePerArrivingKM = ""
    @Published var changePricePerKM = ""
    
    init() {
        Task {
            user = await DriverAccount()
            if user != nil {
                self.isWorking = user!.isWorking
            }
        }
    }
    
    func updateDrivingData() async {
        do {
            try await db.collection("Driver").document("kV8UifsbilBjYraH5L7D").updateData([
                "isWorking": isWorking,
                "pricePerArrivingKM" : Double(changePricePerArrivingKM),
                "pricePerKM" : Double(changePricePerKM)
            ])
        } catch {
            print(error)
        }
    }
}
