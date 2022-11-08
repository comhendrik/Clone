//
//  UberCloneApp.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
  }
}

@main
struct UberCloneApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
    }
}
