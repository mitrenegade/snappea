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
    @State var confirmation: String = ""
    var body: some View {
        Group {
            if AuthenticationService.shared.user != nil {
                homeView
            } else {
                VStack {
                    Text("Welcome and please login or sign up")
                        .font(.title)
                    Spacer()
                    loginView
                    Spacer()
                    signupView
                }
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
            TextField("email", text: $email)
            SecureField("password", text: $password)
            Button(action: {
                self.doLogin()
            }) {
                Text("Login")
            }
        }
    }
    
    var signupView: some View {
        VStack {
            TextField("email", text: $email)
            SecureField("password", text: $password)
            SecureField("confirm password", text: $password)
            Spacer()
            Button(action: {
                self.doSignup()
            }) {
                Text("Sign up")
            }
        }
    }
    
    func doLogin() {
        AuthenticationService.shared.signIn(email: self.email, password: self.password) { (result, error) in
            if let error = error {
                Alert(title: Text("Could not log in"), message: Text("Login failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("Dismiss")))
            } else {
                Alert(title: Text("Login successful"), message: Text("You have logged in as \(self.email)"), dismissButton: .default(Text("Dismiss")))
            }
        }
    }
        
    func doSignup() {
        guard !self.password.isEmpty, self.confirmation == self.password else {
            Alert(title: Text("Could not sign up"), message: Text("Your password and confirmation do not match."), dismissButton: .default(Text("Dismiss")))
            return
        }
        
        AuthenticationService.shared.signUp(email: self.email, password: self.password) { (result, error) in
            if let error = error {
                Alert(title: Text("Could not sign up"), message: Text("Signup failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
