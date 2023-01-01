//
//  LoginView.swift
//  Driver
//
//  Created by Hendrik Steen on 31.12.22.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel : LoginViewModel
    @AppStorage("log_status") var status = false
    var body: some View {
        VStack {
            Text("Login")
            TextField("email", text: $loginViewModel.email)
            TextField("password", text: $loginViewModel.password)
            Button {
                DispatchQueue.main.async {
                    Task {
                        self.status = await loginViewModel.login()
                    }
                }
            } label: {
                Text("Login")
            }
            .alert(loginViewModel.alertMsg, isPresented: $loginViewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
            
        }
    }
}
