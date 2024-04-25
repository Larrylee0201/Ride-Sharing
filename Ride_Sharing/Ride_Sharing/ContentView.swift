//
//  ContentView.swift
//  Ride_Sharing
//
//  Created by Larry on 4/22/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Ride Sharing!")
                    .font(.title)
                    .foregroundColor(.blue)
                
                Image(systemName: "car")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text("Ride sharing is an app that helps you to find someone who wants to share a ride with a cheaper price!")
                    .multilineTextAlignment(.center)
                    .padding()
                
                NavigationLink(destination: PostcardView()) { // 導航到 PostView
                    Text("Let's Start!")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
