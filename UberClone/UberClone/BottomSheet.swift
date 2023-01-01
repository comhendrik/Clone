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
    @EnvironmentObject var avm: ApplicationViewModel
    var body: some View {
        VStack {
            Spacer()
            CustomDraggableComponent()
                .environmentObject(lvm)
                .environmentObject(avm)
            
        }
        
    }
}

//TODO: refactor this view into multiple sub views

let MIN_HEIGHT: CGFloat = 30

struct CustomDraggableComponent: View {
    @State var height: CGFloat = MIN_HEIGHT
    @EnvironmentObject var lvm: LocationViewModel
    @EnvironmentObject var avm: ApplicationViewModel
    
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
                            
                            
                            
                            if avm.currentDrive != nil {
                                DriverInformation(userLocation: lvm.userLocation!, driver: avm.currentDrive!.driver)
                                
                                
                                
                                if avm.driveState == .notBooked {
                                    
                                    MoneyInformationView(drive: avm.currentDrive!)
                                    
                                    HStack {
                                        Button {
                                            withAnimation() {
                                                avm.driveState = avm.currentDrive!.bookDrive()
                                                if avm.driveState != .notBooked {
                                                    avm.mapAnnotations = []
                                                    avm.mapAnnotations.append(CustomMapAnnotation(location: avm.currentDrive!.destination, type: .destination))
                                                }
                                                
                                            }
                                        } label: {
                                            HStack {
                                                Spacer()
                                                Text("Book \(String(format: "%.02f", avm.currentDrive!.calculateDriveCost()))$")
                                                    .foregroundColor(.white)
                                                    .padding()
                                                Spacer()
                                            }
                                                
                                                .background(avm.driveState != .notBooked ? Color.gray.cornerRadius(20) : Color.blue.cornerRadius(20))
                                                .padding(.leading)
                                            
                                        }
                                        
                                        Button {
                                            withAnimation() {
                                                avm.currentDrive = nil
                                            }
                                        } label: {
                                            Text("Cancel")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(avm.driveState != .notBooked ? Color.gray.cornerRadius(20) : Color.red.cornerRadius(20))
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                
                                
                                
                                
                                HStack {
                                    Image(systemName: avm.driveState.systemImage)
                                        .font(.largeTitle)
                                        .foregroundColor(avm.driveState.systemImageColor)
                                    Text(avm.driveState.responseValue)
                                        .fontWeight(.bold)
                                }
                                .padding()
                                
                                if avm.driveState == .success {
                                    Button {
                                        withAnimation() {
                                            avm.deleteDrive(afterBooking: false)
                                            
                                        }
                                        avm.mapAnnotations.removeAll()
                                    } label: {
                                        Text("Get Next Ride")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.blue.cornerRadius(30))
                                            .padding()
                                    }

                                } else if avm.driveState == .arriving {
                                    Button {
                                        withAnimation() {
                                            avm.stepIntoCar()
                                        }
                                    } label: {
                                        Text("Step into car")
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color.blue.cornerRadius(30))
                                            .padding()
                                    }
                                } else if avm.driveState == .pending {
                                    HStack {
                                        Button {
                                            withAnimation() {
                                                avm.deleteDrive(afterBooking: true)
                                            }
                                        } label: {
                                            Text("Cancel Booking")
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color.red.cornerRadius(20))
                                                .padding(.horizontal)
                                        }
                                        Button {
                                            avm.driveState = avm.currentDrive!.getNewestInformation(with: .arriving)
                                            
                                        } label: {
                                            VStack {
                                                Image(systemName: "arrow.counterclockwise")
                                                    .font(.title)
                                                Text("Refresh")
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    Text("(You have to pay a fee to the driver.)")
                                        .font(.subheadline)
                                    
                                } else if avm.driveState == .driving {
                                    Button {
                                        avm.driveState = avm.currentDrive!.getNewestInformation(with: .success)
                                        
                                    } label: {
                                        VStack {
                                            Image(systemName: "arrow.counterclockwise")
                                                .font(.title)
                                            Text("Refresh")
                                        }
                                    }
                                    .padding()
                                    
                                }

                                
                            } else {
                                SearchBottomSheet()
                                    .environmentObject(lvm)
                                    .environmentObject(avm)
                                if avm.mapAnnotations.count  > 0 {
                                    HStack {
                                        VStack(spacing: 0) {
                                              Image(systemName: "car.circle")
                                                .font(.title)
                                                .foregroundColor(.blue)
                                              
                                              Image(systemName: "arrowtriangle.down.fill")
                                                .font(.caption)
                                                .foregroundColor(.blue)
                                                .offset(x: 0, y: -5)
                                        }
                                        Text("Use one of the \(avm.mapAnnotations.count - 1) option(s) on the map.")
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
    
    @State private var showSettings = false
    
    @State private var showAlert = false
    @State private var alertMsg = ""
    
    @EnvironmentObject var lvm: LocationViewModel
    
    @EnvironmentObject var avm: ApplicationViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "location.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                TextField("destination", text: $endPosition)
                Spacer()
                Button {
                    showSettings.toggle()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.gray)
                        .font(.title)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView(showSettings: $showSettings)
                    
                }

            }
            .padding()
            
            HStack {
                Text("Which type do you want?")
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.leading)
            
            SelectDrivingModeView(mode: $currentDrivingMode)
            
            Button {
                Task {
                    self.alertMsg = await avm.setRouteLocations(userLocation: lvm.userLocation, end: endPosition, ride: currentDrivingMode, radius: 50)
                    self.showAlert.toggle()
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
            .alert(alertMsg, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
            
            

            
        }
        
    }
}




