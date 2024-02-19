//
//  ContentView.swift
//  Snappy
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

    let viewModel: LoginViewModel

    @ObservedObject var authStore: AuthStore

    @StateObject var store = LocalStore()

    init(viewModel: LoginViewModel = LoginViewModel(),
         authStore: AuthStore = AuthStore.shared) {
        self.viewModel = viewModel
        self.authStore = authStore
//        // BR TODO edit this when user changes
//        if let id = authStore.user?.id {
//            store = LocalStore()
////        } else {
////            store = MockStore()
//        }
    }

    var body: some View {
        Group {
            if !$authStore.isLoggedIn.wrappedValue {
                VStack {
                    Text("Welcome and please login or sign up")
                        .font(.title)
                    Spacer()
                    loginView
                    Spacer()
                    signupView
                }
            } else {
                HomeView(router: HomeViewRouter(), store: store)
            }
        }
        .alert(isPresented: $showingAlert) {
            self.alert ?? Alert(title: Text("Unknown error"))
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
        Task {
            do {
                _ = try await viewModel.signIn(email: self.email, password: self.password)
            } catch {
                DispatchQueue.main.async {
                    self.alert = Alert(title: Text("Could not log in"), message: Text("Login failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("Dismiss")))
                    self.showingAlert.toggle()
                }
            }
        }
    }
        
    func doSignup() {
        guard !self.password.isEmpty, self.confirmation == self.password else {
            self.alert = Alert(title: Text("Could not sign up"), message: Text("Your password and confirmation do not match."), dismissButton: .default(Text("Dismiss")))
            self.showingAlert.toggle()
            return
        }

        Task {
            do {
                try await viewModel.signUp(email: self.email, password: self.password)
            } catch {
                DispatchQueue.main.async {
                    self.alert = Alert(title: Text("Could not sign up"), message: Text("Signup failed! Error: \(error.localizedDescription)"), dismissButton: .default(Text("OK")))
                    self.showingAlert.toggle()
                }
            }
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
