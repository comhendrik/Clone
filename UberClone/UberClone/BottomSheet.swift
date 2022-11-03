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
                      if height < 200 {
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
                        if height >= 200 {
                            
                            
                            
                            if applicationViewModel.currentDrive != nil {
                                DriverInformation(userLocation: lvm.userLocation!, driver: applicationViewModel.currentDrive!.driver)
                                
                                if applicationViewModel.driveState == .notBooked {
                                    HStack {
                                        Button {
                                            withAnimation() {
                                                applicationViewModel.driveState = applicationViewModel.currentDrive!.bookDrive()
                                                if applicationViewModel.driveState != .notBooked {
                                                    lvm.driveOptions = []
                                                }
                                                
                                            }
                                        } label: {
                                            HStack {
                                                Spacer()
                                                Text("Book \(String(format: "%.02f", applicationViewModel.currentDrive!.cost))$")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                Spacer()
                                            }
                                                
                                                .background(applicationViewModel.driveState != .notBooked ? Color.gray.cornerRadius(20) : Color.blue.cornerRadius(20))
                                                .padding(.leading)
                                            
                                        }
                                        
                                        Button {
                                            withAnimation() {
                                                applicationViewModel.currentDrive = nil
                                            }
                                        } label: {
                                            Text("Cancel")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(applicationViewModel.driveState != .notBooked ? Color.gray.cornerRadius(20) : Color.red.cornerRadius(20))
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                
                                
                                
                                
                                HStack {
                                    Image(systemName: applicationViewModel.driveState.systemImage)
                                        .font(.largeTitle)
                                        .foregroundColor(applicationViewModel.driveState.systemImageColor)
                                    Text(applicationViewModel.driveState.responseValue)
                                        .fontWeight(.bold)
                                }
                                
                                if applicationViewModel.driveState == .success {
                                    Button {
                                        withAnimation() {
                                            applicationViewModel.deleteDrive()
                                        }
                                    } label: {
                                        Text("Get Next Ride")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.blue.cornerRadius(30))
                                            .padding()
                                    }

                                } else if applicationViewModel.driveState == .arriving {
                                    Button {
                                        withAnimation() {
                                            applicationViewModel.stepIntoCar()
                                        }
                                    } label: {
                                        Text("Step into car")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.blue.cornerRadius(30))
                                            .padding()
                                    }
                                }
                                
                                
                                
                                if applicationViewModel.driveState != .notBooked {
                                    Button {
                                        applicationViewModel.driveState = .arriving
                                    } label: {
                                        Text("trigger arriving")
                                    }
                                }

                                
                            } else {
                                SearchBottomSheet()
                                    .environmentObject(lvm)
                                    .environmentObject(applicationViewModel)
                                if lvm.driveOptions.count > 0 {
                                    HStack {
                                        VStack(spacing: 0) {
                                              Image(systemName: "mappin.circle.fill")
                                                .font(.title)
                                                .foregroundColor(.blue)
                                              
                                              Image(systemName: "arrowtriangle.down.fill")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                                .offset(x: 0, y: -5)
                                        }
                                        Text("Use one of the \(lvm.driveOptions.count) option(s) on the map.")
                                    }
                                }
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
                HStack {
                    Spacer()
                    Text("Search")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.blue.cornerRadius(20))
                .padding()
                    
            }
            .alert(lvm.alertMsg, isPresented: $lvm.showAlert) {
                        Button("OK", role: .cancel) { }
                    }

            
        }
        
    }
}




