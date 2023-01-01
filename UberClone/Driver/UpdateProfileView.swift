//
//  CreateProfileView.swift
//  Driver
//
//  Created by Hendrik Steen on 29.12.22.
//

import SwiftUI
import FirebaseAuth

struct UpdateProfileView: View {
    @StateObject var accountViewModel : AccountViewModel
    var body: some View {
        if accountViewModel.user != nil {
            VStack {
                Button {
                    print(accountViewModel.user!.id)
                    print(accountViewModel.user!.firstName)
                    print(Auth.auth().currentUser!.uid)
                } label: {
                    Text("test")
                }

                Text("Set up your drive")
                Toggle(isOn: $accountViewModel.isWorking) {
                    Text("Change working status")
                }
                TextField("arrivingKm", text: $accountViewModel.changePricePerArrivingKM)
                TextField("km", text: $accountViewModel.changePricePerKM)
                Button {
                    accountViewModel.updateDrivingData()
                } label: {
                    Text("Start Driving")
                }
                .alert(accountViewModel.alertMsg, isPresented: $accountViewModel.showAlert) {
                            Button("OK", role: .cancel) { }
                        }

            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

