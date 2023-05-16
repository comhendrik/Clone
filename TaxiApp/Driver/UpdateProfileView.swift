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
    @Binding var showUpdateProfileView: Bool
    var body: some View {
        if accountViewModel.user != nil {
            VStack {
                Button {
                    showUpdateProfileView.toggle()
                } label: {
                    Text("Close")
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
                    Text("Let the world know what you've changed")
                }
                .alert(accountViewModel.alertMsg, isPresented: $accountViewModel.showAlert) {
                            Button("OK", role: .cancel) {
                                showUpdateProfileView.toggle()
                            }
                        }
                

            }
            .onAppear() {
                accountViewModel.changePricePerKM = String(accountViewModel.user!.pricePerKM)
                accountViewModel.changePricePerArrivingKM = String(accountViewModel.user!.pricePerArrivingKM)
            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
}

