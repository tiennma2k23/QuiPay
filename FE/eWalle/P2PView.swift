import SwiftUI

// Structs to decode JSON response
struct BankAccount2: Decodable {
    let accountNo: String
    let bankName: String
    let balance: Double
    let wallet: Wallet2
    let bankBin: String
}

struct Wallet2: Decodable {
    let walletId: Int
    let balance: Double
    let customer: Customer
}

struct Customer: Decodable {
    let customerId: Int
    let customerName: String
    let mobileNumber: String
    let password: String
}

struct Merchant: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
    let volume: Double
    let minAmount: Int
    let maxAmount: Int
    let trades: Int
    let successRate: Double
    let responseTime: String
}

// Helper functions
func getOrCreateUUID1() -> String {
    let userDefaults = UserDefaults.standard
    if let uuid = userDefaults.string(forKey: "uuid") {
        return uuid
    } else {
        let newUUID = UUID().uuidString
        userDefaults.set(newUUID, forKey: "uuid")
        return newUUID
    }
}

func getMobileNumber1() -> String {
    let userDefaults = UserDefaults.standard
    if let mobileNumber = userDefaults.string(forKey: "phoneNumber") {
        return mobileNumber
    } else {
        // Handle case where mobile number is not set
        return ""
    }
}

func fetchBankAccounts(completion: @escaping ([BankAccount2]) -> Void) {
    let uuid = getOrCreateUUID1()
    guard let url = URL(string: "http://localhost:8484/customer/bankaccount/getall?key=\(uuid)") else {
        print("Invalid URL")
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                let bankAccounts = try JSONDecoder().decode([BankAccount2].self, from: data)
                completion(bankAccounts)
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        } else if let error = error {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }.resume()
}

func fetchSolanaBalance1(publicKey: String, completion: @escaping (Double) -> Void) {
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

func fetchTotalBalance(filteredAccounts: [BankAccount2], completion: @escaping ([Int: Double]) -> Void) {
    var customerBalances: [Int: Double] = [:]
    let group = DispatchGroup()

    for account in filteredAccounts {
        group.enter()
        fetchSolanaBalance1(publicKey: account.accountNo) { balance in
            let customerId = account.wallet.customer.customerId
            customerBalances[customerId, default: 0.0] += balance / 1e9
            group.leave()
        }
    }

    group.notify(queue: .main) {
        completion(customerBalances)
    }
}

// View components
struct P2PView: View {
    @State private var merchants: [Merchant] = []
    @State private var selectedCurrency = "NGN"
    @State private var selectedCrypto = "BTC"
    @State private var selectedMerchantName: String?

    var body: some View {
        NavigationView {
            VStack {
                List(merchants) { merchant in
                    NavigationLink(destination: BuyView(merchant: merchant)) {
                        MerchantRow(merchant: merchant)
                    }
                }
                .onAppear {
                    fetchBankAccounts { accounts in
                        let filteredAccounts = accounts.filter { $0.bankName == "Solana" }
                        fetchTotalBalance(filteredAccounts: filteredAccounts) { customerBalances in
                            let phoneNumber = getMobileNumber1()
                            let merchantsData = accounts
                                .filter { $0.wallet.customer.mobileNumber != phoneNumber }
                                .map { account -> Merchant in
                                    let totalBalance = customerBalances[account.wallet.customer.customerId] ?? 0.0
                                    return Merchant(
                                        name: account.wallet.customer.customerName,
                                        price: 100,
                                        volume: totalBalance,
                                        minAmount: 100000,
                                        maxAmount: 500000,
                                        trades: 150,
                                        successRate: 98,
                                        responseTime: "5 mins"
                                    )
                                }
                            DispatchQueue.main.async {
                                self.merchants = merchantsData
                            }
                        }
                    }
                }
                .navigationBarTitle("P2P Merchants")
            }
        }
    }
}

struct MerchantRow: View {
    let merchant: Merchant

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 50, height: 50)

                VStack(alignment: .leading) {
                    Text(merchant.name)
                        .font(.headline)

                    Text("₦\(String(format: "%.2f", merchant.price))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
            }

            HStack {
                Text("Volume: \(String(format: "%.4f", merchant.volume)) BTC")
                Spacer()
                Text("Min: ₦\(merchant.minAmount)")
                Spacer()
                Text("Max: ₦\(merchant.maxAmount)")
            }
            .font(.footnote)
            .foregroundColor(.gray)

            HStack {
                Text("\(merchant.trades) Trades")
                Spacer()
                Text("\(merchant.successRate)%")
                Spacer()
                Text(merchant.responseTime)
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        .padding()
    }
}

struct BuyView1: View {
    let merchant: Merchant

    var body: some View {
        VStack {
            Text("Buy View")
                .font(.title)
                .padding()

            Text("Selected Merchant: \(merchant.name)")
                .padding()
        }
        .navigationBarTitle("Buy")
    }
}

struct P2PView_Previews: PreviewProvider {
    static var previews: some View {
        P2PView()
    }
}
