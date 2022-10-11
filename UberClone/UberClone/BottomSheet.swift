//
//  BottomSheet.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI
import MapKit

struct BottomSheet: View {
    @State var clvm: CoreLocationViewModel
    var body: some View {
        VStack {
            Spacer()
            CustomDraggableComponent(clvm: clvm)

            
        }
        
    }
}



let MIN_HEIGHT: CGFloat = 30

struct CustomDraggableComponent: View {
    @State var height: CGFloat = MIN_HEIGHT
    @State var clvm: CoreLocationViewModel
    
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
                            
                            SearchBottomSheet(clvm: clvm)
                            
                            
//                            if height == UIScreen.main.bounds.height - UIScreen.main.bounds.height / 6 {
//                                DriverInformation()
//                                TimeInformation()
//                            }
//
//                            Button {
//
//                            } label: {
//                                Text("BOOK NOW")
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.blue.frame(width: UIScreen.main.bounds.width - 30).cornerRadius(20))
//                            }
//
//                            Spacer()
                        }
                    }
                  )
                
                
            }
            
            
            
          
          
        }
    }
    
}

struct SearchBottomSheet: View {
    @State private var startPosition = ""
    
    @State private var endPosition = ""
    
    let rides = [Ride(id: 0, image: "Car", price: 10.99, drivingMode: .standard), Ride(id: 1, image: "Car", price: 15.99, drivingMode: .medium), Ride(id: 2, image: "Car", price: 21.99, drivingMode: .luxus)]
    
    @State private var currentDrivingMode: DrivingMode = .standard
    
    @State var clvm: CoreLocationViewModel
    
    var body: some View {
        VStack {
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
                    
                    TextField("start", text: $startPosition)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 1, height: UIScreen.main.bounds.height / 20)
                    TextField("destination", text: $endPosition)
                }
                Spacer()
                
            }
            .padding()
            
            HStack {
                Text("Which type do you want?")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.leading)
            HStack {
                
                ForEach(rides) { ride in
                    
                    Spacer()
                    
                    Button(action: {
                        currentDrivingMode = ride.drivingMode
                    }, label: {
                        VStack {
                            Image(ride.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width / 6)
                            VStack(alignment: .leading) {
                                Text(ride.drivingMode.stringValue)
                                    .foregroundColor(currentDrivingMode == ride.drivingMode ? .white : .black)
                                    .fontWeight(.bold)
                                Text("\(String(format: "%.2f", ride.price))$")
                                    .foregroundColor(currentDrivingMode == ride.drivingMode ? .white : .gray)
                            }
                        }
                        .padding()
                        .background(currentDrivingMode == ride.drivingMode ? Color.blue.cornerRadius(20) : Color.gray.opacity(0.25).cornerRadius(20))
                    })
                    Spacer()
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            
            Button {
                
                Task {
                    await clvm.setRouteLocations(start: startPosition, end: endPosition, ride: currentDrivingMode)
                }
                
                
            } label: {
                Text("Search")
            }

        }
    }
}

//TODO: Refactor Ride and Driving Mode to get them in one enum

enum DrivingMode {
    
    case standard, medium, luxus
    
    var stringValue: String {
        switch self {
        case .standard:
            return "Standard"
        case .medium:
            return "Medium"
        case .luxus:
            return "Luxus"
        }
    }
}



struct Ride: Identifiable {
    var id: Int
    var image: String
    var price: Double
    var drivingMode: DrivingMode
}
