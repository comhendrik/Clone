//
//  BottomSheet.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI

struct BottomSheet: View {
    
    var body: some View {
        VStack {
            
            CustomDraggableComponent()
            Spacer()
              
               // If comment this line the result will be as on the bottom GIF example
            
        }
        
    }
}


struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet()
    }
}


let MIN_HEIGHT: CGFloat = 50

struct CustomDraggableComponent: View {
  @State var height: CGFloat = MIN_HEIGHT
  
  var body: some View {
        VStack {
            Rectangle()
              .fill(Color.red)
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: height)
            HStack {
              Spacer()
              Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 10)
                .cornerRadius(10)
                .gesture(
                  DragGesture()
                    .onChanged { value in
                        height = max(MIN_HEIGHT, height + value.translation.height)
                        
                    }
                    .onEnded({ _ in
                        if height > 400.00 {
                            withAnimation() {
                                height = UIScreen.main.bounds.height - 50
                            }
                        } else {
                            withAnimation() {
                                height = MIN_HEIGHT
                            }
                        }
                    })
                )
              Spacer()
            }
            
          
          
        }
    }
    
}
