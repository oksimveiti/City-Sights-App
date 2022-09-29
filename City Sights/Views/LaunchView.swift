//
//  LaunchView.swift
//  City Sights
//
//  Created by Semih Cetin on 28.09.2022.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        
        // Detect the authorization status of geolocating the user
        
        // if undetermined, show onboarding
        
        // if approved, show homeview
        
        // if denied, show deniedview
        
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world Heloooooo!")
        }
        .padding()
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
