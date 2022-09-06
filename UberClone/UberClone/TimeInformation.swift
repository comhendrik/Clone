//
//  TimeInformation.swift
//  UberClone
//
//  Created by Hendrik Steen on 06.09.22.
//

import SwiftUI

struct TimeInformation: View {
    var body: some View {
        VStack {
            HStack {
                Text("Estimated Time:")
                    .fontWeight(.bold)
                    .padding(.leading)
                    
                Spacer()
                
            }
            HStack {
                VStack {
                    Text("3 min")
                        .fontWeight(.bold)
                    Text("Arriving time")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                Text("+")
                    .fontWeight(.bold)
                
                VStack {
                    Text("30 min")
                        .fontWeight(.bold)
                    Text("Driving time")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                Text("=")
                    .fontWeight(.bold)
                
                VStack {
                    Text("35 min")
                        .fontWeight(.bold)
                    Text("Total time")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1).cornerRadius(20).frame(width: UIScreen.main.bounds.width - 30))
            .padding(.bottom)
            
            
        }
        
    }
}

struct TimeInformation_Previews: PreviewProvider {
    static var previews: some View {
        TimeInformation()
    }
}
