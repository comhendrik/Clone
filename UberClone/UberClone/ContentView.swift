//
//  ContentView.swift
//  UberClone
//
//  Created by Hendrik Steen on 30.08.22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                Text("hello")
                Spacer()
                BottomSheet()
            }
            .tabItem {
                Image(systemName: "person")
                Text("test")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
