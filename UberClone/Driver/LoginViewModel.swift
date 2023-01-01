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
    
    //Signup
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    
    //PasswordReset
    @Published var resetEmail = ""
    @Published var signUpView = false
    
    //Register data
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var car: Car = Car(name: "", type: .medium)
    @Published var definePricePerArrivingKM: String = "0.0"
    @Published var defingePricePerKM: String = "0.0"
    
    //Um Fehler anzuzeigen, wird ein Alert verwendet
    @Published var showAlert = false
    @Published var alertMsg = ""
    
    @Published var showRegisterView = false
    
    @AppStorage("current_status") var statusofregister = false
    
    let user = Auth.auth().currentUser
    
    
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
            
            
            let id = res.user.uid
            
            let userDoc = try await db.collection("Driver").whereField("id", isEqualTo: id).getDocuments()
            
            if userDoc.isEmpty {
                await MainActor.run {
                    self.showRegisterView.toggle()
                }
            } else {
                print("user is registered")
            }
            
            return true
            
            
        } catch {
            print(error.localizedDescription)
            return false
        }
            
            
            
            
//            if !user!.isEmailVerified {
  //              self.alertMsg = "Please verify"
    //            self.alert.toggle()
      //          do {
        //           try Auth.auth().signOut()
          //      } catch {
            //        print(error)
                //}
          //  }
            
    }
    
    func registerNewUserData() {
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
                         "pricePerKm"         : pricePerKM,
                         "isWorking"          : false,
                         "rating"             : 0.0,
                         //Dummy Data
                         "geohash"            : "u1wqk8x8vtvy",
                         "latitude"           : 54.53904,
                         "longitude"          : 8.99736
                        ])
                    showRegisterView = false
                } else {
                    print("no email")
                }
            } else {
                print("no user")
            }
        } else {
            print("no double values")
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
    
    
    
    func SignUp() {
        //Diese Funktion ermöglicht das registieren.
        //Überprüfung, ob Werte eingegeben wurden.
        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == "" {
            self.alertMsg = "Fill Content properly"
            self.showAlert.toggle()
            return
        }
        //Das Passwort muss zweimal richtig eingegeben werden.
        if password_SignUp != reEnterPassword {
            self.alertMsg = "password missmatch"
            self.showAlert.toggle()
            return
        }
        //createUser per FirebaseAuth
        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp) { (res, err) in
            if err != nil {
                self.alertMsg = err!.localizedDescription
                self.showAlert.toggle()
                return
            }
            //Es wird eine Verifizierungsemail an die verwendete Email gesendet.
            res?.user.sendEmailVerification(completion: { (err) in
                if err != nil {
                    self.alertMsg = err!.localizedDescription
                    self.showAlert.toggle()
                    return
                }
                //Benachrichtigung an den Nutzer per Alert, damit dieser weiß, was er danach tun muss.
                self.alertMsg = "Verify Link has been sent. Verify your email and login after you did it"
                self.showAlert.toggle()
                
            })
        }
    }
    
    func logOut() {
        //Diese Funktion ermöglicht ein signOut. Alle Werte werden zurückgesetzt
        try! Auth.auth().signOut()
        
        self.statusofregister = false
        
        email = ""
        password = ""
        email_SignUp = ""
        password_SignUp = ""
        reEnterPassword = ""
        
    }
}
