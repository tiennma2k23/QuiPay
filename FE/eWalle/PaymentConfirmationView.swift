import SwiftUI

struct PaymentConfirmationView: View {
    @State private var receiver = ""
    @State private var phoneNumber = ""
    @State private var message = "Tớ gửi tiền nhé"
    @State private var amountOfMoney = "100000"
    @State private var discountCode = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingPinEntry = false
    @State private var showSuccessSendView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                GroupBox(label: Label("Account transfer", systemImage: "arrow.right.arrow.left")) {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Receiver")
                            Spacer()
                            Text(receiver)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Phone number")
                            Spacer()
                            TextField("Enter phone number", text: $phoneNumber)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                        HStack {
                            Text("Message")
                            Spacer()
                            TextField("Enter message", text: $message)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                }
                
                GroupBox(label: HStack {
                    Image("QuiPayLogo") // Replace with your image name
                    Text("E-Wallet QuiPay")
                }) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Balance: \(formatBalance(250000))")
                        HStack {
                            Text("Amount of money")
                            Spacer()
                            TextField("Enter amount", text: $amountOfMoney)
                                .multilineTextAlignment(.trailing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        HStack {
                            Text("Discount")
                            Spacer()
                            Text("0%") // This could be dynamically updated based on discountCode
                        }
                        HStack {
                            Text("Fee")
                            Spacer()
                            Text("Free")
                        }
                        NavigationLink(destination: DiscountCodeView(discountCode: $discountCode)) {
                            HStack {
                                Text("Discount Code")
                                Spacer()
                                Text(discountCode.isEmpty ? "Choose now" : discountCode)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding()
                }
                
                Text("International standard security PCI-DSS")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        if validateInput() {
                            showingPinEntry = true
                        } else {
                            showingAlert = true
                        }
                    }) {
                        HStack {
                            Text("Paid")
                            Image(systemName: "checkmark.shield")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.leading)
                    
                    VStack(alignment: .leading) {
                        Text("Total Money")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text(amountOfMoney)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .padding(.trailing)
                }
                .padding(.bottom)
            }
            .padding()
            .navigationBarTitle("Payment confirmation", displayMode: .inline)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $showingPinEntry) {
                PinEntryView(showingPinEntry: $showingPinEntry, showSuccessSendView: $showSuccessSendView)
            }
            .fullScreenCover(isPresented: $showSuccessSendView) {
                SuccessSendView(receiver: receiver, phoneNumber: phoneNumber, message: message, totalMoney: amountOfMoney, showSuccessSendView: $showSuccessSendView)
            }
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
    
    func formatBalance(_ balance: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD" // Change to your desired currency
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    func validateInput() -> Bool {
        // Validate phone number format
        if phoneNumber.isEmpty {
            alertMessage = "Invalid phone number."
            showingAlert = true
            return false
        }
        
        // Call API to find account
        let apiUrl = "http://localhost:8484/mywallet/findaccount?phoneNumber=\(phoneNumber)"
        guard let url = URL(string: apiUrl) else {
            alertMessage = "Invalid API URL."
            showingAlert = true
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                alertMessage = "Network error: \(error?.localizedDescription ?? "Unknown error")"
                showingAlert = true
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    // Update receiver if account found
                    receiver = user.customerName
                }
            } catch {
                alertMessage = "Error decoding response: \(error.localizedDescription)"
                showingAlert = true
            }
        }
        
        task.resume()
        
        // Always return true immediately; the actual validation result is handled asynchronously
        return true
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DiscountCodeView: View {
    @Binding var discountCode: String
    @State private var newDiscountCode = ""

    var body: some View {
        VStack {
            TextField("Enter discount code", text: $newDiscountCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Apply") {
                applyDiscountCode()
            }
            .padding()

            Spacer()
        }
        .navigationBarTitle("Enter Discount Code", displayMode: .inline)
    }

    func applyDiscountCode() {
        // Add validation or discount code logic here
        discountCode = newDiscountCode
    }
}

struct PinEntryView: View {
    @Binding var showingPinEntry: Bool
    @Binding var showSuccessSendView: Bool
    @State private var pin = ""

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.2)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismissKeyboard()
                        showingPinEntry = false
                    }

                VStack(spacing: 0) {
                    Spacer()

                    VStack {
                        Text("Password")
                            .font(.headline)
                            .padding()

                        SecureField("PIN", text: $pin)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: geometry.size.height / 2)

                        Button("Confirm") {
                            // Handle PIN confirmation
                            showingPinEntry = false
                            showSuccessSendView = true
                        }
                        .padding()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)

                    Spacer()
                }
            }
            .opacity(showingPinEntry ? 1 : 0)
            .animation(.easeInOut)
        }
    }

    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SuccessSendView: View {
    let receiver: String
    let phoneNumber: String
    let message: String
    let totalMoney: String
    @Binding var showSuccessSendView: Bool
    
    var body: some View {
        VStack {
            // Green Success Header
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                Text("Success")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.green)
            
            // Details Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Receiver")
                        .fontWeight(.bold)
                    Spacer()
                    Text(receiver)
                }
                HStack {
                    Text("Phone number")
                        .fontWeight(.bold)
                    Spacer()
                    Text(phoneNumber)
                }
                HStack {
                    Text("Message")
                        .fontWeight(.bold)
                    Spacer()
                    Text(message)
                }
                HStack {
                    Text("Total Money")
                        .fontWeight(.bold)
                    Spacer()
                    Text(totalMoney)
                }
            }
            .padding()
            
            Spacer()
            
            // Buttons
            HStack {
                Button(action: {
                    // Handle new transaction
                    showSuccessSendView = false
                }) {
                    Text("New transaction")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: HomeScreen()) {
                    Text("Homepage")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
}


struct PaymentConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentConfirmationView()
    }
}
