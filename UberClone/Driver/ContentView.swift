//
//  ContentView.swift
//  Driver
//
//  Created by Hendrik Steen on 26.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var accountViewModel = AccountViewModel()
    var body: some View {
        Text("Hello, world!")
            .padding()
        Button {
            if accountViewModel.user != nil {
                print(accountViewModel.user!.firstName)
            }
        } label: {
            Text("Test")
        }


    }
}

