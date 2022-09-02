//
//  BottomSheet.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI

struct BottomSheet: View {
    @State private var fullSheet = false
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.red)
                .frame(width: UIScreen.main.bounds.width, height: fullSheet ? nil : UIScreen.main.bounds.height / 2.5)
                .cornerRadius(25)
                .overlay(
                    Button {
                        withAnimation() {
                            fullSheet.toggle()
                        }
                    } label: {
                        VStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                                .frame(width: UIScreen.main.bounds.width / 7.5, height: 15)
                            Spacer()
                        }
                        .padding()
                    }
                )
            
            

        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet()
    }
}
