import SwiftUI

struct PaymentConfirmationView: View {
    @State private var receiver = "Nguyễn Văn A"
    @State private var phoneNumber = "093 4465 088"
    @State private var message = "Tớ gửi tiền nhé"
    @State private var amountOfMoney = "100.000"
    @State private var discountCode = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingPinEntry = false
    
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
                PinEntryView(showingPinEntry: $showingPinEntry)
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
        if phoneNumber.isEmpty || !phoneNumber.matches(regex: "^[0-9]{3} [0-9]{4} [0-9]{3}$") || !phoneNumber.matches(regex: "^[0-9]{10}$"){
            alertMessage = "Invalid phone number."
            return false
        }
        if amountOfMoney.isEmpty || Double(amountOfMoney) == nil {
            alertMessage = "Invalid amount of money."
            return false
        }
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

extension String {
    func matches(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}

struct PaymentConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentConfirmationView()
    }
}

