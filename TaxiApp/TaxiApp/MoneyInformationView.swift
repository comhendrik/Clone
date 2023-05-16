//
//  MoneyInformationView.swift
//  UberClone
//
//  Created by Hendrik Steen on 05.11.22.
//

import SwiftUI

struct MoneyInformationView: View {
    let possibleDriver: PossibleDriver
    var body: some View {
        VStack(alignment: .leading) {
            
            CostTextView(title: "Base fee: ", costCalculation: "\(String(format: "%.02f", possibleDriver.car.type.price))$")
            CostTextView(title: "Arriving fee: ", costCalculation: "\(String(format: "%.02f", possibleDriver.getDistanceFromUser(userLocation: possibleDriver.start))) km  * \(String(format: "%.02f", possibleDriver.pricePerArrivingKM))$ = \(String(format: "%.02f", possibleDriver.calculateCostForArriving()))$")
            CostTextView(title: "Travelling fee: ", costCalculation: "\(String(format: "%.02f", possibleDriver.calculateDrivingDistance())) km * \(String(format: "%.02f", possibleDriver.pricePerKM))$ = \(String(format: "%.02f", possibleDriver.calculateCostForRide()))$")
            
            
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

