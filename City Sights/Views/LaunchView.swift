//
//  LaunchView.swift
//  City Sights
//
//  Created by Semih Cetin on 28.09.2022.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
