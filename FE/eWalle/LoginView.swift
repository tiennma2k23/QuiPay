import SwiftUI

// Mô hình dữ liệu cho yêu cầu đăng nhập
struct UserLogin: Codable {
    let mobileNumber: String
    let password: String
}

struct LoginView: View {
    @State private var mobileNumber: String = ""
    @State private var password: String = ""
    @State private var is2FAEnabled: Bool = false
    @State private var loginMessage: String?
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                WalletLogo()
                    .padding(.bottom, 40)

                SignInText()
                    .padding(.bottom, 40)

                MobileNumberTextField(mobileNumber: $mobileNumber)
                    .padding(.horizontal, 20)

                PasswordSecureField(password: $password)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                ForgotPasswordLink()
                    .padding(.top, 10)
                    .padding(.trailing, 20)

                TwoFAToggle(is2FAEnabled: $is2FAEnabled)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                if is2FAEnabled {
                    TwoFAInputField()
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                }

                Spacer()

                SignInButton {
                    loginUser(mobileNumber: mobileNumber, password: password)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                
                if let message = loginMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .padding()
                }

                NavigationLink(destination: HomeScreen(), isActive: $isLoggedIn) {
                    EmptyView()
                }
            }
            .alert(isPresented: Binding<Bool>(
                get: { self.loginMessage != nil },
                set: { _ in self.loginMessage = nil }
            )) {
                Alert(title: Text("Login Status"), message: Text(loginMessage ?? ""), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func loginUser(mobileNumber: String, password: String) {
        let userLogin = UserLogin(mobileNumber: mobileNumber, password: password)
        guard let url = URL(string: "http://localhost:8484/user/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(userLogin)
            request.httpBody = jsonData
        } catch {
            DispatchQueue.main.async {
                self.loginMessage = "Error encoding JSON: \(error.localizedDescription)"
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginMessage = "Failed to connect to server: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            
            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.loginMessage = "Login successful!"
                }
            } else {
                if let data = data, let message = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.loginMessage = "Login failed: \(message)"
                    }
                } else {
                    DispatchQueue.main.async {
                        self.loginMessage = "Login failed with status code: \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
}

struct WalletLogo: View {
    var body: some View {
        Image("WalletLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .accessibility(label: Text("Wallet Logo"))
    }
}

struct SignInText: View {
    var body: some View {
        Text("SIGN IN")
            .font(.largeTitle)
            .fontWeight(.bold)
            .accessibility(label: Text("Sign In"))
    }
}

struct MobileNumberTextField: View {
    @Binding var mobileNumber: String
    
    var body: some View {
        TextField("Mobile Number", text: $mobileNumber)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .keyboardType(.phonePad)
            .autocapitalization(.none)
            .accessibility(label: Text("Mobile Number"))
            .accessibility(hint: Text("Enter your mobile number"))
    }
}

struct PasswordSecureField: View {
    @Binding var password: String
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .accessibility(label: Text("Password"))
            .accessibility(hint: Text("Enter your password"))
    }
}

struct ForgotPasswordLink: View {
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                // Action for forgot password
            }) {
                Text("Forgot password?")
                    .foregroundColor(.blue)
            }
            .accessibility(label: Text("Forgot Password"))
            .accessibility(hint: Text("Tap to reset your password"))
        }
    }
}

struct TwoFAToggle: View {
    @Binding var is2FAEnabled: Bool
    
    var body: some View {
        Toggle(isOn: $is2FAEnabled) {
            Text("Enable 2FA authentication")
        }
        .accessibility(label: Text("Enable Two Factor Authentication"))
    }
}

struct TwoFAInputField: View {
    @State private var twoFACode: String = ""
    
    var body: some View {
        TextField("2FA Code", text: $twoFACode)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .keyboardType(.numberPad)
            .accessibility(label: Text("Two Factor Authentication Code"))
            .accessibility(hint: Text("Enter your 2FA code"))
    }
}

struct SignInButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text("Sign In")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
                .accessibility(label: Text("Sign In Button"))
                .accessibility(hint: Text("Tap to sign in"))
        }
    }
}

//struct HomeScreen: View {
//    var body: some View {
//        Text("Welcome to the Home Screen!")
//            .font(.largeTitle)
//            .padding()
//    }
//}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
