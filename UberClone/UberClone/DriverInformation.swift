//
//  DriverInformation.swift
//  UberClone
//
//  Created by Hendrik Steen on 06.09.22.
//

import SwiftUI
import CoreLocation

struct DriverInformation: View {
    let userLocation: CLLocation
    let drive: Drive
    
    var body: some View {
        VStack {
            HStack {
                Text("Selected Driver:")
                    .fontWeight(.bold)
                    .padding(.leading)
                Spacer()
            }
            HStack {
                Image("profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width / 5, height: UIScreen.main.bounds.width / 5)
                    .cornerRadius(15)
                    .padding(.leading)
                VStack(alignment: .leading) {
                    Text("\(drive.firstName) \(drive.lastName)")
                        .fontWeight(.bold)
                    Text("\(String(format:"%.02f", drive.getDistanceFromUser(userLocation: userLocation))) KMs away")
                        .foregroundColor(.gray)
                    Text("Rating: \(String(format: "%.01f", drive.rating))")
                        .foregroundColor(.gray)
                    Text("\(drive.car.name)")
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1).cornerRadius(20).frame(width: UIScreen.main.bounds.width - 30))
            
            
            
        }
        
        
    }
}

