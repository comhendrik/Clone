//
//  AccountViewModel.swift
//  Driver
//
//  Created by Hendrik Steen on 26.11.22.
//

import SwiftUI
import Foundation

class AccountViewModel: ObservableObject {
    @Published var user: DriverAccount? = nil
    
    init() {
        Task{
            user = await DriverAccount()
        }
    }
}
