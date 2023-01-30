//
//  DrivingView.swift
//  Driver
//
//  Created by Hendrik Steen on 18.01.23.
//

import SwiftUI

//TODO: Add option when user canceled Drive
struct DrivingView: View {
    @StateObject var accountViewModel: AccountViewModel
    @Binding var showDrivingSheet: Bool
    @Binding var showMoreInformation: Bool
    var body: some View {
        VStack {
            HStack {
                Button {
                    showDrivingSheet.toggle()
                    showMoreInformation = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding()
            Spacer()
            if accountViewModel.actualDrive != nil {
                Button {
                    if accountViewModel.updateDriveStatus() {
                        showDrivingSheet.toggle()
                        showMoreInformation.toggle()
                    }
                } label: {
                    Text(accountViewModel.actualDrive!.driveStatus.responseValue)
                }
                Button {
                    accountViewModel.getNewestInformationsForActualDrive()
                } label: {
                    Text("Refresh")
                }

            } else {
                Text("Accept a drive to start driving!")
            }
            Spacer()
        }
    }
}
