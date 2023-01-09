//
//  LoginViewModel.swift
//  Driver
//
//  Created by Hendrik Steen on 31.12.22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var reEnterPassword = ""
    
    //PasswordReset
    @Published var resetEmail = ""
    @Published var signUpView = false
    
    //Register data
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var car: Car = Car(name: "", type: .medium)
    @Published var definePricePerArrivingKM: String = ""
    @Published var defingePricePerKM: String = ""
    
    //Um Fehler anzuzeigen, wird ein Alert verwendet
    @Published var showAlert = false
    @Published var alertMsg = ""
    
    @Published var showRegisterView = false
    
    @AppStorage("current_status") var statusofregister = false
    
    
    
    
    func login() async -> Bool {

        if email == "" || password == "" {
            await MainActor.run {
                self.alertMsg = "Fill the contents properly"
                self.showAlert.toggle()
            }
            return false
        }
        
        
        do {
            let res = try await Auth.auth().signIn(withEmail: email, password: password)
            
            if !res.user.isEmailVerified {
                await MainActor.run {
                    self.alertMsg = "Please verify"
                    self.showAlert.toggle()
                }
                
                try Auth.auth().signOut()
            }
            
            if  await !userIsRegistered() {
                await MainActor.run {
                    self.showRegisterView.toggle()
                }
            }
            
            
            
            
            return true
            
            
        } catch {
            await MainActor.run {
                self.alertMsg = error.localizedDescription
                self.showAlert.toggle()
            }
            return false
        }
            
            
            
            
            
            
    }
    
    func userIsRegistered() async -> Bool {
        let user = Auth.auth().currentUser
        if let id = user?.uid {
            do {
                let userDoc = try await db.collection("Driver").whereField("id", isEqualTo: id).getDocuments()
                
                if userDoc.isEmpty {
                    return false
                }
                return true
            } catch {
                return false
            }
        }
        return false
        
    }
    
    func registerNewUserData() -> String {
        let user = Auth.auth().currentUser
        if firstName == "" || lastName == "" {
            print("yeah")
            return "Please check your name input."
        } else if car.name == "" {
            return "Please check your car name."
        }
        //Dummy data is used partially
        if let pricePerArrivingKM = definePricePerArrivingKM.doubleValue, let pricePerKM = defingePricePerKM.doubleValue {
            if user != nil  {
                if user!.email != nil {
                    let doc = db.collection("Driver").document(user!.uid)
                    doc.setData(
                        ["firstName"         : firstName,
                         "lastName"           : lastName,
                         "email"              : user!.email!,
                         "carName"            : car.name,
                         "carType"            : car.type.intValue,
                         "id"                 : doc.documentID,
                         "pricePerArrivingKM" : pricePerArrivingKM,
                         "pricePerKM"         : pricePerKM,
                         "isWorking"          : false,
                         "rating"             : 0.0,
                         //Dummy Data
                         "geohash"            : "u1wqk8x8vtvy",
                         "latitude"           : 54.53904,
                         "longitude"          : 8.99736
                        ])
                    return "Registered succesfully"
                } else {
                    return "No access to an email adress."
                }
            } else {
                return "No user. Please reload or log out and try it again"
            }
        } else {
            return "Check the values for your prices"
        }
    }
    
    func resetPassword() {
        //Diese Funktion ermöglicht das Zurücksetzen des Passworts.
        resetEmail = email
        if resetEmail != "" {
            Auth.auth().sendPasswordReset(withEmail: resetEmail) { (err) in
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.showAlert.toggle()
                    return
                }
                
                self.alertMsg = "Reset Email has been sent. Check all your folders its maybe in the spam folder"
                self.showAlert.toggle()
            }
        } else {
            self.alertMsg = "Please select an email"
            self.showAlert.toggle()
        }
    }
    
    
    
    func signUp() async {
        
        if email == "" || password == "" || reEnterPassword == "" {
            await MainActor.run {
                self.alertMsg = "Fill Content properly"
                self.showAlert.toggle()
            }
            return
        }
        //Das Passwort muss zweimal richtig eingegeben werden.
        if password != reEnterPassword {
            await MainActor.run {
                self.alertMsg = "password missmatch"
                self.showAlert.toggle()
            }
            return
        }
        
        
        do {
            let res = try await Auth.auth().createUser(withEmail: email, password: password)
            
            try await res.user.sendEmailVerification()
            
            await MainActor.run {
                self.alertMsg = "Verify Link has been sent. Verify your email and login after you did it"
                self.showAlert.toggle()
            }
            return
        } catch {
            await MainActor.run {
                self.alertMsg = error.localizedDescription
                self.showAlert.toggle()
                
            }
            return
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            
            self.statusofregister = false
            
            email = ""
            password = ""
            reEnterPassword = ""
        } catch {
            self.alertMsg = error.localizedDescription
            self.showAlert.toggle()
        }
        
    }
}
