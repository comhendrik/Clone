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
    
    
    //Um sich weiter zu registrieren wird Vorname und Nachname, sowie Geburtstag und Addresse als auch ein Profilbild gebraucht.
    @Published var firstName = ""
    @Published var lastName = ""
    
    //Um Fehler anzuzeigen, wird ein Alert verwendet
    @Published var showAlert = false
    @Published var alertMsg = ""
    
    //Siehe Erklärung ContentView:
    
    @AppStorage("current_status") var statusofregister = false
    
    let user = Auth.auth().currentUser
    
    
    func login() async -> Bool {

        if email == "" || password == "" {
            self.alertMsg = "Fill the contents properly"
            self.showAlert.toggle()
            return false
        }
        
        
        do {
            let res = try await Auth.auth().signIn(withEmail: email, password: password)
            
            
            let id = res.user.uid
            
            let userDoc = try await db.collection("Driver").whereField("id", isEqualTo: id).getDocuments()
            
            if userDoc.isEmpty {
                registerNewUserData()
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
        print("We want to register new data")
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
