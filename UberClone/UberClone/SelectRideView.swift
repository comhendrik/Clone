//
//  SelectRideView.swift
//  UberClone
//
//  Created by Hendrik Steen on 04.09.22.
//

import SwiftUI

struct SelectRideView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.blue)
                Text("Your position")
            }
            HStack {
                Rectangle()
                    .frame(width: 2.5, height: 10, alignment: .leading)
                Divider()
            }
            HStack {
                Image(systemName: "figure.wave")
                    .foregroundColor(.blue)
                Text("Your destination")
            }
        }
    }
}

struct SelectRideView_Previews: PreviewProvider {
    static var previews: some View {
        SelectRideView()
    }
}
