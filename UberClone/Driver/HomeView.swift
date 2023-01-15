//
//  HomeView.swift
//  Driver
//
//  Created by Hendrik Steen on 09.01.23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var accountViewModel: AccountViewModel
    @State private var showUpdateProfileView = false
    var body: some View {
        VStack {
            PossibleDrivesView(accountViewModel: accountViewModel)
            Button {
                showUpdateProfileView.toggle()
            } label: {
                Text("Settings")
            }

        }
        .sheet(isPresented: $showUpdateProfileView) {
            UpdateProfileView(accountViewModel: accountViewModel, showUpdateProfileView: $showUpdateProfileView)
        }
        
            
    }
}
