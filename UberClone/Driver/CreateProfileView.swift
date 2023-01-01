//
//  CreateProfileView.swift
//  Driver
//
//  Created by Hendrik Steen on 01.01.23.
//

import SwiftUI

struct CreateProfileView: View {
    @StateObject var loginViewModel: LoginViewModel
    var body: some View {
        VStack {
            Text("Create your new account")
            TextField("firstname", text: $loginViewModel.firstName)
            TextField("lastname", text: $loginViewModel.lastName)
            Text("Car Information:")
            TextField("firstname", text: $loginViewModel.car.name)
            SelectDrivingModeView(mode: $loginViewModel.car.type)
            TextField("pricePerArrivingKM", text: $loginViewModel.definePricePerArrivingKM)
            TextField("pricePerKM", text: $loginViewModel.defingePricePerKM)
            
            Button(action: {
                loginViewModel.registerNewUserData()
            }, label: {
                Text("Register")
            })
            
            
        }
    }
}

