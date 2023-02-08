//
//  DrivingView.swift
//  UberClone
//
//  Created by Hendrik Steen on 07.02.23.
//

import SwiftUI

//TODO: Maybe add the two DrivingView.swift files together

struct DrivingView: View {
    @StateObject var applicationViewModel: ApplicationViewModel
    @Binding var showDrivingSheet: Bool
    var body: some View {
        VStack {
            HStack {
                Button {
                    showDrivingSheet.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding()
            Spacer()
            if applicationViewModel.currentDrive != nil {
                Text(applicationViewModel.currentDrive!.driveStatus.responseValue)
                Button {
                    if applicationViewModel.updateDriveStatus() {
                        showDrivingSheet.toggle()
                    }
                } label: {
                    Text(applicationViewModel.currentDrive!.driveStatus.updateText)
                }
                Button {
                    applicationViewModel.getNewestInformations()
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


