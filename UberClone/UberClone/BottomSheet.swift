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
            Spacer()
            CustomDraggableComponent()
            
              
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
            
            HStack {
              Spacer()
              Rectangle()
                .fill(Color.gray)
                .frame(width: 100, height: 10)
                .cornerRadius(10)
                .gesture(
                  DragGesture()
                    .onChanged { value in
                        print(value.translation.height)
                        if value.translation.height < 0 {
                            height = max(MIN_HEIGHT, height + abs(value.translation.height))
                        } else {
                            height = max(MIN_HEIGHT, height - value.translation.height)
                        }
                        
                        
                    }
                    .onEnded({ _ in
                        if height > 500.00 {
                            withAnimation() {
                                height = UIScreen.main.bounds.height - 50
                            }
                        } else if height < 200 {
                            withAnimation() {
                                height = MIN_HEIGHT
                            }
                        } else {
                            withAnimation() {
                                height = UIScreen.main.bounds.height / 2
                            }
                        }
                    })
                )
              Spacer()
            }
            ZStack {
                Rectangle()
                  .fill(Color.red)
                  .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: height)
                  
//                if height == UIScreen.main.bounds.height - 50 {
//                     LargeView()
//                } else if height == UIScreen.main.bounds.height / 2 {
//                    MediumView()
//                }
                VStack {
                    MediumView()
                    if height == UIScreen.main.bounds.height - 50 {
                        VStack {
                            
                            ForEach(0..<20) { value in
                                Text("\(value)")
                            }
                        }
                    }
                }
                
            }
            
            
            
          
          
        }
    }
    
}

struct LargeView: View {
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                ForEach(0..<20) { value in
                    Text("\(value)")
                }
            }
        }
    }
}

struct MediumView: View {
    var body: some View {
        VStack {
            Text("Medium View")
            Text("fgasjdflkjsdlkfjsdlfjlsdafjlksdafasdfasdfasdfasdfsadf")
        }
    }
}

