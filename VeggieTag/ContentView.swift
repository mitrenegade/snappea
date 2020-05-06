//
//  ContentView.swift
//  VeggieTag
//
//  Created by Bobby Ren on 4/18/20.
//  Copyright © 2020 RenderApps LLC. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmation: String = ""
    @State private var showingAlert = false
    @State private var alert: Alert?
    
    @ObservedObject var auth: AuthenticationService

    init(authService: AuthenticationService =  AuthenticationService.shared) {
        self.auth = authService
    }

    var body: some View {
        Group {
            if auth.user != nil {
                homeView
            } else if auth.user == nil {
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
        .alert(isPresented: $showingAlert) {
            self.alert ?? Alert(title: Text("Unknown error"))
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
            SecureField("confirm password", text: $confirmation)
            Button(action: {
                self.doSignup()
            }) {
                Text("Sign up")
            }
        }
    }
    
    func doLogin() {
        auth.signIn(email: self.email, password: self.password) { (result, error) in
            if let error = error {
                self.alert = Alert(title: Text("Could not log in"), message: Text("Login failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("Dismiss")))
                self.showingAlert.toggle()
            } else {
                self.alert = Alert(title: Text("Login successful"), message: Text("You have logged in as \(self.email)"), dismissButton: .default(Text("Dismiss")))
                self.showingAlert.toggle()
            }
        }
    }
        
    func doSignup() {
        guard !self.password.isEmpty, self.confirmation == self.password else {
            self.alert = Alert(title: Text("Could not sign up"), message: Text("Your password and confirmation do not match."), dismissButton: .default(Text("Dismiss")))
            self.showingAlert.toggle()
            return
        }
        
        auth.signUp(email: self.email, password: self.password) { (result, error) in
            if let error = error {
                self.alert = Alert(title: Text("Could not sign up"), message: Text("Signup failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("OK")))
                self.showingAlert.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
