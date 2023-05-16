//
//  SelectDrivingModeView.swift
//  Driver, Uberclone
//
//  Created by Hendrik Steen on 01.01.23.
//

import SwiftUI

struct SelectDrivingModeView: View {
    @Binding var mode: DrivingMode
    var body: some View {
        HStack {
            ForEach(DrivingMode.allCases, id: \.rawValue) { drivingMode in
                
                HStack {
                    Button(action: {
                        mode = drivingMode
                    }, label: {
                        VStack(alignment: .leading) {
                            Text(drivingMode.stringValue)
                                .foregroundColor(mode == drivingMode ? .white : .black)
                                .fontWeight(.black)
                            Text("$ \(drivingMode.price, specifier: "%.2f")")
                                .foregroundColor(mode == drivingMode ? .white : .gray)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        .padding()
                        .background(mode == drivingMode ? .blue : .gray.opacity(0.1))
                        .cornerRadius(20)
                    })
                    if drivingMode != .luxus {
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
