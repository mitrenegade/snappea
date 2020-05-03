//
//  ContentView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/18/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        Group {
            if AuthenticationService.shared.user != nil {
                homeView
            } else {
                loginView
            }
        }
    }
    
    var homeView: some View {
        TabView {
            PhotosListView()
            .tabItem {
                Image(systemName: "phone.fill")
                Text("Photos")
              }
            CameraRoot()
            .tabItem {
                 Image(systemName: "phone.fill")
                 Text("Camera")
               }
        }
    }
    
    // mark: login
    var loginView: some View {
        VStack {
            Text("Welcome and please login or sign up")
                .font(.title)
            Spacer()
            TextField("email", text: $email)
            SecureField("password", text: $password)
            Spacer()
            Button(action: {
                self.doLogin()
            }) {
                Text("Login")
            }
        }
    }
    
    func doLogin() {
        AuthenticationService.shared.signIn(email: self.email, password: self.password) { (result, error) in
            if let error = error {
                Alert(title: Text("Could not log in"), message: Text("Login failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("Dismiss")){
                    })
            } else {
                Alert(title: Text("Login successful"), message: Text("You have logged in as \(self.email)"), dismissButton: .default(Text("Dismiss")){
                    
                    })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
