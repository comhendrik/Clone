//
//  BottomSheet.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI
import MapKit

struct BottomSheet: View {
    @EnvironmentObject var clvm: CoreLocationViewModel
    @EnvironmentObject var lvm: LocationViewModel
    var body: some View {
        VStack {
            Spacer()
            CustomDraggableComponent()
                .environmentObject(lvm)
                .environmentObject(clvm)
            
        }
        
    }
}



let MIN_HEIGHT: CGFloat = 30

struct CustomDraggableComponent: View {
    @State var height: CGFloat = MIN_HEIGHT
    @EnvironmentObject var clvm: CoreLocationViewModel
    @EnvironmentObject var lvm: LocationViewModel
    
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
                            
                            SearchBottomSheet()
                                .environmentObject(lvm)
                                .environmentObject(clvm)
                            
                            
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
    
    @State private var endPosition = ""
    
    @State private var currentDrivingMode: DrivingMode = .standard
    
    @EnvironmentObject var clvm: CoreLocationViewModel
    @EnvironmentObject var lvm: LocationViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "location.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                TextField("destination", text: $endPosition)
                
            }
            .padding()
            
            HStack {
                Text("Which type do you want?")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.leading)
            HStack {
                
                ForEach(DrivingMode.allCases, id: \.rawValue) { drivingMode in
                    
                    Spacer()
                    
                    Button(action: {
                        currentDrivingMode = drivingMode
                    }, label: {
                        Text(drivingMode.stringValue)
                            .foregroundColor(currentDrivingMode == drivingMode ? .blue : .gray)
                    })
                    Spacer()
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            
            Button {
                Task {
                    await clvm.setRouteLocations(end: endPosition, ride: currentDrivingMode)
                }
            } label: {
                Text("Search")
            }
            .alert(clvm.alertMsg, isPresented: $clvm.showAlert) {
                        Button("OK", role: .cancel) { }
                    }

            
        }
        
    }
}


enum DrivingMode: String, CaseIterable {
    
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
    
    var image: String {
        "Car"
    }
    
    var price: Double {
        switch self {
        case .standard:
            return 10.99
        case .medium:
            return 15.99
        case .luxus:
            return 20.99
        }
    }
}

