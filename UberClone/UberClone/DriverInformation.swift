//
//  DriverInformation.swift
//  UberClone
//
//  Created by Hendrik Steen on 06.09.22.
//

import SwiftUI

struct DriverInformation: View {
    var body: some View {
        VStack {
            HStack {
                Text("Driver:")
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
                    Text("Max Mustermann")
                        .fontWeight(.bold)
                    Text("3 min away")
                        .foregroundColor(.gray)
                    Text("Rating: 4.5")
                        .foregroundColor(.gray)
                    Text("Tesla Model S")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1).cornerRadius(20).frame(width: UIScreen.main.bounds.width - 30))
            .padding(.bottom)
        }
        
        
    }
}

struct DriverInformation_Previews: PreviewProvider {
    static var previews: some View {
        DriverInformation()
    }
}
