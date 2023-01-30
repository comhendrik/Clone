//
//  MoneyInformationView.swift
//  UberClone
//
//  Created by Hendrik Steen on 05.11.22.
//

import SwiftUI

struct MoneyInformationView: View {
    let drive: Drive
    var body: some View {
        VStack(alignment: .leading) {
            
            CostTextView(title: "Base fee: ", costCalculation: "\(String(format: "%.02f", drive.car.type.price))$")
            CostTextView(title: "Arriving fee: ", costCalculation: "\(String(format: "%.02f", drive.getDistanceFromUser(userLocation: drive.start))) km  * \(String(format: "%.02f", drive.pricePerArrivingKM))$ = \(String(format: "%.02f", drive.calculateCostForArriving()))$")
            CostTextView(title: "Travelling fee: ", costCalculation: "\(String(format: "%.02f", drive.calculateDrivingDistance())) km * \(String(format: "%.02f", drive.pricePerKM))$ = \(String(format: "%.02f", drive.calculateCostForRide()))$")
            
            
        }
        
            .padding()
            .background(Color.gray.opacity(0.1).cornerRadius(20).frame(width: UIScreen.main.bounds.width - 30))
            .padding(.bottom)
    }
}

struct CostTextView: View {
    var title: String
    var costCalculation: String
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(costCalculation)
                .font(.subheadline)
        }
        .padding(.horizontal)
    }
}

