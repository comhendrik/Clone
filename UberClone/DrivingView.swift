//
//  DrivingView.swift
//  UberClone, Driver
//
//  Created by Hendrik Steen on 07.02.23.
//

import SwiftUI

struct DrivingView: View {
    var drive: Drive?
    var closeAction: () -> Void
    var updateAction: () -> Void
    var refreshAction: () -> Void
    var body: some View {
        VStack {
            HStack {
                Button {
                    closeAction()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding()
            Spacer()
            if drive != nil {
                Text(drive!.driveStatus.responseValue)
                Button {
                    updateAction()
                } label: {
                    Text(drive!.driveStatus.updateText)
                }
                Button {
                    refreshAction()
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


