import SwiftUI

struct AddWalletView: View {
    
    @State private var walletName: String = ""
    @State private var walletType: String = "Cryptocurrency"
    @State private var currencyType: String = "Bitcoin"
    @State private var bitcoinAddress: String = ""
    @State private var bankAccountNumber: String = ""
    @State private var bankName: String = "Viettinbank"
    @State private var cardNumber: String = ""
    @State private var cardExpiryDate: String = ""
    @State private var cardHolderName: String = ""
    @State private var cardCSV: String = ""
    
    let walletTypes = ["Cryptocurrency", "Banking", "Napas Card", "Visa Card"]
    let currencyTypes = ["Bitcoin", "EOS", "Tether"]
    let banks = ["Viettinbank", "Vietcombank", "BIDV"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Wallet name", text: $walletName)
                    .autocapitalization(.none)
                
                Picker("Wallet type", selection: $walletType) {
                    ForEach(walletTypes, id: \.self) { type in
                        Text(type)
                    }
                }
                .pickerStyle(DefaultPickerStyle())  // Use DefaultPickerStyle for compatibility
                
                if walletType == "Cryptocurrency" {
                    Picker("Currency type", selection: $currencyType) {
                        ForEach(currencyTypes, id: \.self) { currency in
                            Text(currency)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Your Bitcoin Address", text: $bitcoinAddress)
                        .keyboardType(.asciiCapable)
                    
                } else if walletType == "Banking" {
                    TextField("Bank Account Number", text: $bankAccountNumber)
                        .keyboardType(.numberPad)
                    
                    Picker("Bank Name", selection: $bankName) {
                        ForEach(banks, id: \.self) { bank in
                            Text(bank)
                        }
                    }
                    .pickerStyle(DefaultPickerStyle())
                    TextField("Holder Name", text: $cardHolderName)
                        .autocapitalization(.words)
                    
                } else if walletType == "Napas Card" || walletType == "Visa Card" {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    
                    TextField("Card Expiry Date", text: $cardExpiryDate)
                        .keyboardType(.numbersAndPunctuation)
                    
                    TextField("Card Holder Name", text: $cardHolderName)
                        .autocapitalization(.words)
                    
                    if walletType == "Visa Card" {
                        TextField("Card CSV", text: $cardCSV)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .navigationBarTitle("New Wallet", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                // Handle cancel action
            }, trailing: Button("Save") {
                // Handle save action
                saveWallet()
            })
        }
    }
    
    private func saveWallet() {
        // Implement the save functionality here
        print("Wallet saved: \(walletName), \(walletType), \(currencyType), \(bitcoinAddress), \(bankAccountNumber), \(bankName), \(cardNumber), \(cardExpiryDate), \(cardHolderName), \(cardCSV)")
    }
}
struct AddWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddWalletView()
    }
}
