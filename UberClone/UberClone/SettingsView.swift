//
//  SettingsView.swift
//  UberClone
//
//  Created by Hendrik Steen on 07.11.22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    var body: some View {
        Image(systemName: "gearshape")
            .foregroundColor(.black)
            .font(.largeTitle)
    }
}

