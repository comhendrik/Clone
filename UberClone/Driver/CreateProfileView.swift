//
//  CreateProfileView.swift
//  Driver
//
//  Created by Hendrik Steen on 29.12.22.
//

import SwiftUI

struct CreateProfileView: View {
    @StateObject var accountViewModel : AccountViewModel
    var body: some View {
        if accountViewModel.user != nil {
            VStack {
                Text("Set up your drive")
                Toggle(isOn: $accountViewModel.isWorking) {
                    Text("Change working status")
                }
                TextField("arrivingKm", text: $accountViewModel.changePricePerArrivingKM)
                TextField("km", text: $accountViewModel.changePricePerKM)
                Button {
                    Task {
                        await accountViewModel.updateDrivingData()
                    }
                } label: {
                    Text("Start Driving")
                }

            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

