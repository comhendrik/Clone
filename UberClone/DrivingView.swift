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
                Spacer()
            }
            .padding()
            Spacer()
            if drive != nil {
                HStack {
                    Image(systemName: drive!.driveStatus.systemImage)
                    Text(drive!.driveStatus.responseValue)
                }
                HStack {
                    Button {
                        refreshAction()
                    } label: {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                    }
                    Button {
                        updateAction()
                    } label: {
                        Text(drive!.driveStatus.updateText)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue.cornerRadius(30))
                    }
                }
            } else {
                Text("Accept a drive to start driving!")
            }
            Spacer()
        }
    }
}


