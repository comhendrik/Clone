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

            
        }
        
    }
}


struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet()
    }
}


let MIN_HEIGHT: CGFloat = 30

struct CustomDraggableComponent: View {
  @State var height: CGFloat = MIN_HEIGHT
  
  var body: some View {
      VStack(spacing: 0) {
            Rectangle()
              .fill(Color.white)
              .frame(height: 30)
              .overlay(Rectangle().fill(Color.gray).frame(width: 100, height: 10).cornerRadius(20))
              .padding(.bottom, 20)
                      .cornerRadius(20)
                      .padding(.bottom, -20)
              .gesture(
                DragGesture()
                  .onChanged { value in
                      if value.translation.height < 0 {
                          height = max(MIN_HEIGHT, height + abs(value.translation.height))
                      } else {
                          height = max(MIN_HEIGHT, height - value.translation.height)
                      }
                      
                      
                  }
                  .onEnded({ _ in
                      if height > 500.00 {
                          withAnimation() {
                              height = UIScreen.main.bounds.height - UIScreen.main.bounds.height / 6
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
            ZStack {
                Rectangle()
                    .fill(Color.white)
                  .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: height)
                  .overlay(
                    VStack {
                        if height >= UIScreen.main.bounds.height / 2 {
                            HStack {
                                VStack {
                                    Image(systemName: "location.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                    Rectangle()
                                        .frame(width: 1, height: UIScreen.main.bounds.height / 25)
                                    Image(systemName: "figure.wave")
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                }
                                VStack(alignment: .leading) {
                                    
                                    Text("Your position")
                                        .fontWeight(.bold)
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 1, height: UIScreen.main.bounds.height / 20)
                                    Text("Your destination")
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                
                            }
                            .padding()
                            
                            HStack {
                                Text("Suggested Rides:")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.leading)
                            HStack {
                                Button(action: {
                                    
                                }, label: {
                                    VStack {
                                        Image("Car")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width / 6)
                                        VStack(alignment: .leading) {
                                            Text("Standard")
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                            Text("15.99$")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .padding()
                                    .background(Color.blue.cornerRadius(20))
                                })
                                
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    VStack {
                                        Image("Car")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width / 6)
                                        VStack(alignment: .leading) {
                                            Text("Standard")
                                                .foregroundColor(.black)
                                                .fontWeight(.bold)
                                            Text("15.99$")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.25).cornerRadius(20))
                                })
                                Spacer()
                                Button(action: {
                                    
                                }, label: {
                                    VStack {
                                        Image("Car")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: UIScreen.main.bounds.width / 6)
                                        VStack(alignment: .leading) {
                                            Text("Standard")
                                                .foregroundColor(.black)
                                                .fontWeight(.bold)
                                            Text("15.99$")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.25).cornerRadius(20))
                                })
                                
                            }
                            .frame(width: UIScreen.main.bounds.width - 30)
                            
                            if height == UIScreen.main.bounds.height - UIScreen.main.bounds.height / 6 {
                                DriverInformation()
                                TimeInformation()
                            }
                            
                            Button {
                                
                            } label: {
                                Text("BOOK NOW")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue.frame(width: UIScreen.main.bounds.width - 30).cornerRadius(20))
                            }

                            Spacer()
                        }
                    }
                  )
                
                
            }
            
            
            
          
          
        }
    }
    
}
