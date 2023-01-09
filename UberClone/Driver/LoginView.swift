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
    @State private var showSignUpView = false
    var body: some View {
        VStack {
            Text(showSignUpView ? "SignUp" : "Login")
            TextField("email", text: $loginViewModel.email)
            TextField("password", text: $loginViewModel.password)
            if showSignUpView {
                TextField("re-enter password", text: $loginViewModel.reEnterPassword)
            }
            Button {
                DispatchQueue.main.async {
                    Task {
                        if showSignUpView {
                            await loginViewModel.signUp()
                        } else {
                            self.status = await loginViewModel.login()
                        }
                    }
                }
            } label: {
                Text(showSignUpView ? "SignUp" : "Login")
            }
            .alert(loginViewModel.alertMsg, isPresented: $loginViewModel.showAlert) {
                Button("OK", role: .cancel) { }
            }
            
            Button {
                withAnimation() {
                    showSignUpView.toggle()
                }
            } label: {
                Text("Change to \(showSignUpView ? "Login" : "SignUp")")
            }


            
        }
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
    }
}


