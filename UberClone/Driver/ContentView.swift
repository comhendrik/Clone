//
//  ContentView.swift
//  Driver
//
//  Created by Hendrik Steen on 26.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var accountViewModel = AccountViewModel()
    @StateObject var loginViewModel = LoginViewModel()
    @AppStorage("log_status") var status = false
    var body: some View {
        
        if status {
            if loginViewModel.showRegisterView {
                CreateProfileView(loginViewModel: loginViewModel)
            } else {
                UpdateProfileView(accountViewModel: accountViewModel)
                    .onAppear {
                        accountViewModel.loadDriver()
                    }
                Button {
                    loginViewModel.logOut()
                    status = false
                } label: {
                    Text("Logout")
                }
            }
            
        } else {
            LoginView(loginViewModel: loginViewModel)
        }
        
        
        
        


    }
}

