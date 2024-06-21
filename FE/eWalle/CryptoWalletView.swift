import SwiftUI

// Structs to decode JSON response
struct BankAccount1: Decodable {
    let accountNo: String
    let bankName: String
    let balance: Double
    let wallet: Wallet1
    let bankBin: String
}

struct Wallet1: Decodable {
    let walletId: Int
    let balance: Double
    let customer: Customer1
}

struct Customer1: Decodable {
    let customerId: Int
    let customerName: String
    let mobileNumber: String
    let password: String
}

struct ActionButtonData: Identifiable {
    var id = UUID()
    var icon: String
    var label: String
}

struct CoinData: Identifiable {
    var id = UUID()
    var name: String
    var amount: String
    var value: String
    var change: String
    var changeColor: Color
    var publicKey: String
    var balance: Double
}

// Helper functions
func getOrCreateUUID() -> String {
    let userDefaults = UserDefaults.standard
    if let uuid = userDefaults.string(forKey: "uuid") {
        return uuid
    } else {
        let newUUID = UUID().uuidString
        userDefaults.set(newUUID, forKey: "uuid")
        return newUUID
    }
}

func getMobileNumber() -> String {
    let userDefaults = UserDefaults.standard
    if let mobileNumber = userDefaults.string(forKey: "phoneNumber") {
        return mobileNumber
    } else {
        // Handle case where mobile number is not set
        return ""
    }
}

func fetchBankAccounts(completion: @escaping ([BankAccount1]) -> Void) {
    let uuid = getOrCreateUUID()
    guard let url = URL(string: "http://localhost:8484/customer/bankaccount/all?key=\(uuid)") else {
        print("Invalid URL")
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let bankAccounts = try JSONDecoder().decode([BankAccount1].self, from: data)
                completion(bankAccounts)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        } else if let error = error {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }.resume()
}

func filterBankAccounts(bankAccounts: [BankAccount1]) -> [BankAccount1] {
    let mobileNumber = getMobileNumber()
    return bankAccounts.filter { $0.wallet.customer.mobileNumber == mobileNumber && $0.bankName == "Solana" }
}

func fetchSolanaBalance(publicKey: String, completion: @escaping (Double) -> Void) {
    guard let url = URL(string: "http://localhost:9191/api/solana/balance/get?publicKey=\(publicKey)") else {
        print("Invalid URL")
        completion(0.0)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let balanceString = String(data: data, encoding: .utf8), let balance = Double(balanceString) {
                completion(balance)
            } else {
                print("Failed to parse balance")
                completion(0.0)
            }
        } else if let error = error {
            print("Fetch balance failed: \(error.localizedDescription)")
            completion(0.0)
        }
    }.resume()
}

func fetchTotalBalance(filteredAccounts: [BankAccount1], completion: @escaping (Double) -> Void) {
    let group = DispatchGroup()
    var totalBalance: Double = 0.0

    for account in filteredAccounts {
        group.enter()
        fetchSolanaBalance(publicKey: account.accountNo) { balance in
            totalBalance += balance
            group.leave()
        }
    }

    group.notify(queue: .main) {
        completion(totalBalance / 1e9)
    }
}

// SwiftUI Views
struct CryptoWalletView: View {
    @State private var totalBalance: Double = 0.0
    @State private var solCoinDataList: [CoinData] = []

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("Crypto Wallet")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 20) {
                        Image(systemName: "arrow.2.circlepath")
                            .foregroundColor(.white)
                        Image(systemName: "clock")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Balance Section
                VStack {
                    Text("TOTAL BALANCE")
                        .foregroundColor(.gray)
                    Text("\(totalBalance, specifier: "%.2f") SOL")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    // Placeholder for percentage change, you can calculate it similarly
                    HStack {
                        Text("+7.50%")
                            .foregroundColor(.green)
                        Text("+6,05.10 SOL")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                
                // Action Buttons
                HStack(spacing: 20) {
                    ForEach(actionButtonsData) { buttonData in
                        ActionButton(icon: buttonData.icon, label: buttonData.label)
                    }
                }
                .padding(.horizontal)
                
                // Coin List
                List {
                    ForEach(solCoinDataList) { coinData in
                        CoinRow(coinData: coinData)
                            .listRowBackground(Color.black)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.black)
            .navigationBarHidden(true)
            .onAppear {
                fetchBankAccounts { accounts in
                    let filteredAccounts = filterBankAccounts(bankAccounts: accounts)
                    fetchTotalBalance(filteredAccounts: filteredAccounts) { balance in
                        self.totalBalance = balance
                        UserDefaults.standard.set(balance, forKey: "SOLTotalBalance") // Save to UserDefaults
                    }
                    
                    // Create solCoinDataList
                    var coinDataList: [CoinData] = []
                    for account in filteredAccounts {
                        fetchSolanaBalance(publicKey: account.accountNo) { balance in
                            let coinData = CoinData(
                                name: "SOL",
                                amount: "\(account.balance / 1E9) SOL",
                                value: "",
                                change: "--",
                                changeColor: .gray,
                                publicKey: account.accountNo,
                                balance: balance / 1E9
                            )
                            DispatchQueue.main.async {
                                coinDataList.append(coinData)
                                self.solCoinDataList = coinDataList
                            }
                        }
                    }
                }
            }
        }
    }
}

struct ActionButton: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.purple)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())
            Text(label)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
}

struct CoinRow: View {
    let coinData: CoinData
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(coinData.name)
                    .foregroundColor(.white)
                    .font(.headline)
                Text(coinData.amount)
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text("Public Key: \(coinData.publicKey)")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                Text("Balance: \(coinData.balance, specifier: "%.2f")")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(coinData.value)
                    .foregroundColor(.white)
                    .font(.headline)
                Text(coinData.change)
                    .foregroundColor(coinData.changeColor)
                    .font(.subheadline)
            }
        }
        .padding()
    }
}

struct CryptoWalletView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoWalletView()
    }
}


// Sample Data
let actionButtonsData = [
    ActionButtonData(icon: "plus", label: "Buy"),
    ActionButtonData(icon: "minus", label: "Sell"),
    ActionButtonData(icon: "bag", label: "P2P"),
    ActionButtonData(icon: "arrow.left.arrow.right", label: "Transfer"),
    ActionButtonData(icon: "handshake", label: "Trade")
]
