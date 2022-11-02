//
//  BottomSheet.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI
import MapKit

struct BottomSheet: View {
    @EnvironmentObject var lvm: LocationViewModel
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    var body: some View {
        VStack {
            Spacer()
            CustomDraggableComponent()
                .environmentObject(lvm)
                .environmentObject(applicationViewModel)
            
        }
        
    }
}

//TODO: refactor this view into multiple sub views

let MIN_HEIGHT: CGFloat = 30

struct CustomDraggableComponent: View {
    @State var height: CGFloat = MIN_HEIGHT
    @EnvironmentObject var lvm: LocationViewModel
    @EnvironmentObject var applicationViewModel: ApplicationViewModel
    
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
                                .environmentObject(applicationViewModel)
                            
                            
                            if height == UIScreen.main.bounds.height - UIScreen.main.bounds.height / 6 {
                                if applicationViewModel.currentDrive != nil {
                                    DriverInformation(userLocation: lvm.userLocation!, driver: applicationViewModel.currentDrive!.driver) {
                                        applicationViewModel.currentDrive = nil
                                    }
                                    
                                }
                                
                            } else {
                                if applicationViewModel.currentDrive != nil {
                                    SmallDriverInformation(driver: applicationViewModel.currentDrive!.driver) {
                                        applicationViewModel.currentDrive = nil
                                    }
                                }
                            }
                            
                            if applicationViewModel.currentDrive != nil {
                                Button {
                                    applicationViewModel.driveIsBooked = applicationViewModel.currentDrive!.bookDrive()
                                } label: {
                                    Text("Book now")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(applicationViewModel.driveIsBooked ? Color.gray.frame(width: UIScreen.main.bounds.width - 30).cornerRadius(20) : Color.blue.frame(width: UIScreen.main.bounds.width - 30).cornerRadius(20))
                                        
                                    
                                }
                                .disabled(applicationViewModel.driveIsBooked)
                                
                                if applicationViewModel.driveIsBooked {
                                    HStack {
                                        Text("Thank you for booking. We will charge your account:")
                                        Text("\(String(format:"%.02f", applicationViewModel.currentDrive!.cost))$")
                                    }
                                }
                                
                            } else if lvm.driveOptions.count > 0 {
                                Text("Search for rides on the map. \n We found \(lvm.driveOptions.count) option(s) for you!")
                            }
                        }
                        Spacer()
                    }
                  )
                
                
            }
            
            
            
          
          
        }
      
    }
    
}

struct SearchBottomSheet: View {
    
    @State private var endPosition = ""
    
    @State private var currentDrivingMode: DrivingMode = .standard
    
    @EnvironmentObject var lvm: LocationViewModel
    
    @EnvironmentObject var avm: ApplicationViewModel
    
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
                    
                    
                    Button(action: {
                        currentDrivingMode = drivingMode
                    }, label: {
                        VStack(alignment: .leading) {
                            Image(drivingMode.image)
                                .resizable()
                                .scaledToFit()
                                .frame(alignment: .center)
                            VStack(alignment: .leading) {
                                Text(drivingMode.stringValue)
                                    .foregroundColor(currentDrivingMode == drivingMode ? .white : .black)
                                    .fontWeight(.black)
                                Text("$ \(drivingMode.price, specifier: "%.2f")")
                                    .foregroundColor(currentDrivingMode == drivingMode ? .white : .gray)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .background(currentDrivingMode == drivingMode ? .blue : .gray.opacity(0.1))
                        .cornerRadius(20)
                    })
                }
                
                
            }
            .frame(width: UIScreen.main.bounds.width - 30)
            
            Button {
                Task {
                    avm.deleteDrive()
                    await lvm.setRouteLocations(end: endPosition, ride: currentDrivingMode)
                }
            } label: {
                Text("Search")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.frame(width: UIScreen.main.bounds.width - 30).cornerRadius(20))
                    
            }
            .alert(lvm.alertMsg, isPresented: $lvm.showAlert) {
                        Button("OK", role: .cancel) { }
                    }

            
        }
        
    }
}




