//
//  HomeView.swift
//  Driver
//
//  Created by Hendrik Steen on 09.01.23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var accountViewModel: AccountViewModel
    @StateObject var loginViewModel: LoginViewModel
    @State private var showUpdateProfileView = false
    var body: some View {
        VStack {
            PossibleDrivesView(accountViewModel: accountViewModel, loginViewModel: loginViewModel, showUpdateProfileView: $showUpdateProfileView)
            
        }
        .sheet(isPresented: $showUpdateProfileView) {
            UpdateProfileView(accountViewModel: accountViewModel, showUpdateProfileView: $showUpdateProfileView)
        }
        
            
    }
}
