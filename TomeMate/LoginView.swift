//
//  LoginView.swift
//  TomeMate
//
//  Created by NRD on 10/02/2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authManager: AuthManager
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to DnD App")
                .font(.largeTitle).bold()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Register"){
                if email.isEmpty && password.isEmpty {
                    self.errorMessage = "Enter both email and password"
                    return
                }

                authManager.register(email: email, password: password) {
                    result in
                    switch result {
                    case .success:
                        print ("Registration Successful")
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }

            
            Button("Login"){
                if email.isEmpty && password.isEmpty {
                    self.errorMessage = "Enter both email and password"
                    return
                }
                authManager.login(email: email, password: password) {
                    result in
                    switch result {
                    case .success:
                        print ("Login Successful")
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .padding()
    }
}
#Preview {
    LoginView()
        .environmentObject(AuthManager())
}
