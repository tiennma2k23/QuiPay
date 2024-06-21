import SwiftUI

struct BankInfo: Identifiable, Decodable {
    let id: Int
    let name: String
    let code: String
    let bin: String
    let shortName: String
    let logo: String
    let transferSupported: Int
    let lookupSupported: Int
}

class BankService: ObservableObject {
    @Published var banks: [BankInfo] = []
    
    init() {
        fetchBanks()
    }
    
    func fetchBanks() {
        guard let url = URL(string: "https://api.vietqr.io/v2/banks") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(BankListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.banks = decodedResponse.data
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                print("Fetch failed: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct BankListResponse: Decodable {
    let data: [BankInfo]
}

struct AddWalletView: View {
    
    @State private var walletName: String = ""
    @State private var walletTypeIndex: Int = 0
    @State private var currencyTypeIndex: Int = 0
    @State private var bitcoinAddress: String = "2wZ2pccPEajLetuLm48sDo14SFLWvLVCMBgR7MZbyRZF"
    @State private var bankAccountNumber: String = ""
    @State private var selectedBankIndex: Int? = nil
    @State private var cardNumber: String = ""
    @State private var cardExpiryDate: String = ""
    @State private var cardHolderName: String = ""
    @State private var cardCSV: String = ""
    
    @ObservedObject var bankService = BankService()
    @State private var showingBankSelection = false
    @State private var bankName: String = ""
    @State private var accountName: String = ""
    
    let walletTypes = ["Cryptocurrency", "Banking", "Napas Card", "Visa Card"]
    let currencyTypes = ["Solana", "Metamask", "Bitcoin"]
    
    let clientId = "a5565ddc-904f-49e7-8675-3e17c6114833"
    let apiKey = "32256555-542a-490c-b104-54f43c4a6674"
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Wallet name", text: $walletName)
                    .autocapitalization(.none)
                
                VStack(alignment: .leading) {
                    Text("Wallet type")
                    Picker(selection: $walletTypeIndex, label: Text("")) {
                        ForEach(0 ..< walletTypes.count) {
                            Text(self.walletTypes[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if walletTypes[walletTypeIndex] == "Cryptocurrency" {
                    VStack(alignment: .leading) {
                        Text("Currency type")
                        Picker(selection: $currencyTypeIndex, label: Text("")) {
                            ForEach(0 ..< currencyTypes.count) {
                                Text(self.currencyTypes[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    TextField("Your Address", text: $bitcoinAddress)
                        .keyboardType(.asciiCapable)
                    
                    if currencyTypes[currencyTypeIndex] == "Solana" {
                        Button(action: createNewWallet) {
                            Text("Create New Wallet")
                                .foregroundColor(.blue)
                        }
                    }
                    
                } else if walletTypes[walletTypeIndex] == "Banking" {
                    TextField("Bank Account Number", text: $bankAccountNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: bankAccountNumber) { newValue in
                            fetchAccountName()
                        }
                    
                    VStack(alignment: .leading) {
                        Text("Bank Name")
                        Button(action: {
                            self.showingBankSelection.toggle()
                        }) {
                            Text(bankName.isEmpty ? "Select Bank" : bankName)
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showingBankSelection) {
                            BankSelectionView(selectedBankIndex: self.$selectedBankIndex, banks: bankService.banks, bankName: self.$bankName, showingBankSelection: self.$showingBankSelection)
                        }
                    }
                    
                    TextField("Holder Name", text: $cardHolderName)
                        .autocapitalization(.words)
                        .disabled(true)
                        .onAppear {
                            self.cardHolderName = accountName
                        }
                    
                } else if walletTypes[walletTypeIndex] == "Napas Card" || walletTypes[walletTypeIndex] == "Visa Card" {
                    TextField("Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    
                    TextField("Card Expiry Date", text: $cardExpiryDate)
                        .keyboardType(.numbersAndPunctuation)
                    
                    TextField("Card Holder Name", text: $cardHolderName)
                        .autocapitalization(.words)
                    
                    if walletTypes[walletTypeIndex] == "Visa Card" {
                        TextField("Card CSV", text: $cardCSV)
                            .keyboardType(.numberPad)
                    }
                }
                
                Button(action: saveWallet) {
                    Text("Save")
                        .foregroundColor(.blue)
                }
            }
            .navigationBarTitle("New Wallet", displayMode: .inline)
        }
    }
    
    private func saveWallet() {
        let walletType = walletTypes[walletTypeIndex]
        let url = URL(string: "http://localhost:8484/customer/bankaccount/add?key=\(getOrCreateUUID())")!
        
        var payload: [String: Any] = [:]
        
        switch walletType {
        case "Banking":
            if let selectedIndex = selectedBankIndex {
                let selectedBank = bankService.banks[selectedIndex]
                payload = [
                    "accountNo": bankAccountNumber,
                    "bankName": "Banking",
                    "balance": 0,
                    "bankBin": selectedBank.bin
                ]
            }
        case "Napas Card", "Visa Card":
            payload = [
                "accountNo": cardNumber,
                "bankName": walletType,
                "balance": 1,
                "bankBin": "1"
            ]
        case "Cryptocurrency":
            if currencyTypes[currencyTypeIndex] == "Solana" {
                fetchSolanaBalance(publicKey: bitcoinAddress) { balance in
                    payload = [
                        "accountNo": self.bitcoinAddress,
                        "bankName": "Solana",
                        "balance": balance,
                        "bankBin": "1"
                    ]
                    self.sendRequest(url: url, payload: payload)
                }
                return
            }
        default:
            break
        }
        
        sendRequest(url: url, payload: payload)
    }
    
    private func getOrCreateUUID() -> String {
        let userDefaults = UserDefaults.standard
        if let uuid = userDefaults.string(forKey: "uuid") {
            return uuid
        } else {
            let newUUID = UUID().uuidString
            userDefaults.set(newUUID, forKey: "uuid")
            return newUUID
        }
    }
    
    private func sendRequest(url: URL, payload: [String: Any]) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Save request failed: \(error.localizedDescription)")
                } else {
                    print("Wallet saved successfully")
                }
            }.resume()
        } catch {
            print("Failed to create JSON payload: \(error.localizedDescription)")
        }
    }
    
    private func fetchAccountName() {
        guard let url = URL(string: "https://api.vietqr.io/v2/lookup") else {
            print("Invalid URL")
            return
        }
        
        let bin = bankService.banks[selectedBankIndex ?? 0].bin
        let accountNumber = bankAccountNumber
        
        let requestData = ["bin": bin, "accountNumber": accountNumber]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: .prettyPrinted)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(clientId, forHTTPHeaderField: "x-client-id")
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(LookupResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.accountName = decodedResponse.data.accountName
                            self.cardHolderName = decodedResponse.data.accountName
                        }
                    } catch {
                        print("Failed to decode JSON: \(error.localizedDescription)")
                    }
                } else if let error = error {
                    print("Lookup failed: \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func createNewWallet() {
        guard let url = URL(string: "http://localhost:9191/api/solana/wallet/create") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let newAddress = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.bitcoinAddress = newAddress
                    }
                } else {
                    print("Failed to parse new wallet address")
                }
            } else if let error = error {
                print("Create wallet failed: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    private func fetchSolanaBalance(publicKey: String, completion: @escaping (Int) -> Void) {
        guard let url = URL(string: "http://localhost:9191/api/solana/balance/get?publicKey=\(publicKey)") else {
            print("Invalid URL")
            completion(0)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let balanceString = String(data: data, encoding: .utf8), let balance = Int(balanceString) {
                    completion(balance)
                } else {
                    print("Failed to parse balance")
                    completion(0)
                }
            } else if let error = error {
                print("Fetch balance failed: \(error.localizedDescription)")
                completion(0)
            }
        }.resume()
    }
}

struct LookupResponse: Decodable {
    let code: String
    let desc: String
    let data: AccountInfo
}

struct AccountInfo: Decodable {
    let accountName: String
}

struct BankSelectionView: View {
    @Binding var selectedBankIndex: Int?
    var banks: [BankInfo]
    @Binding var bankName: String
    @Binding var showingBankSelection: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(banks.indices, id: \.self) { index in
                    Button(action: {
                        self.selectedBankIndex = index
                        self.bankName = self.banks[index].name
                        self.showingBankSelection = false // Đóng popup khi đã chọn ngân hàng
                    }) {
                        Text(self.banks[index].name)
                    }
                }
            }
            .navigationBarTitle("Select Bank", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                self.showingBankSelection = false // Đóng popup khi nhấn nút Done
            })
        }
    }
}

struct AddWalletView_Previews: PreviewProvider {
    static var previews: some View {
        AddWalletView()
    }
}
