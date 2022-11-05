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
    let driver: Driver
    
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
                    Text("\(driver.firstName) \(driver.lastName)")
                        .fontWeight(.bold)
                    Text("\(String(format:"%.02f", driver.getDistanceFromUser(userLocation: userLocation))) KMs away")
                        .foregroundColor(.gray)
                    Text("Rating: \(String(format: "%.01f", driver.rating))")
                        .foregroundColor(.gray)
                    Text("\(driver.car.name)")
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1).cornerRadius(20).frame(width: UIScreen.main.bounds.width - 30))
            
            
            
        }
        
        
    }
}

