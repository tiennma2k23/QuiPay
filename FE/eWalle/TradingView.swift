import SwiftUI

struct TradingView: View {
    @State private var selectedWallet: WalletType = .bitcoin
    @State private var transactions = sampleTransactions
    @State private var selectedTab: Int = 0

    var totalBalance: Double {
        transactions.reduce(0) { $0 + ($1.isIncome ? $1.amount : -$1.amount) }
    }

    var filteredTransactions: [Transaction] {
        transactions.filter { $0.wallet == selectedWallet }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text(selectedWallet.rawValue)
                        .font(.title)
                    Spacer()
                    Image(systemName: "calendar")
                }
                .padding()

                // Total Balance
                Text("$\(totalBalance, specifier: "%.2f")")
                    .font(.largeTitle)
                    .padding()

                // Filter Tabs
                Picker("Wallet", selection: $selectedWallet) {
                    ForEach(WalletType.allCases, id: \.self) { wallet in
                        Text(wallet.rawValue).tag(wallet)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Transaction List
                List(filteredTransactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.type.rawValue)
                            Text(transaction.wallet.rawValue)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(transaction.isIncome ? "+ \(transaction.amount, specifier: "%.4f") \(transaction.currency)" : "- \(transaction.amount, specifier: "%.2f") \(transaction.currency)")
                            .foregroundColor(transaction.isIncome ? .green : .red)
                    }
                }

                Spacer()

                // Tab Bar
                HStack {
                    Button(action: { self.selectedTab = 0 }) {
                        VStack {
                            Image(systemName: "wallet.pass")
                            Text("Add wallet")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(self.selectedTab == 0 ? Color.blue : Color.clear)
                    .foregroundColor(self.selectedTab == 0 ? .white : .blue)
                    .cornerRadius(10)

                    Button(action: { self.selectedTab = 1 }) {
                        VStack {
                            Image(systemName: "bitcoinsign.circle")
                            Text("Bitcoin")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(self.selectedTab == 1 ? Color.blue : Color.clear)
                    .foregroundColor(self.selectedTab == 1 ? .white : .blue)
                    .cornerRadius(10)

                    Button(action: { self.selectedTab = 2 }) {
                        VStack {
                            Image(systemName: "creditcard")
                            Text("Mastercard")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(self.selectedTab == 2 ? Color.blue : Color.clear)
                    .foregroundColor(self.selectedTab == 2 ? .white : .blue)
                    .cornerRadius(10)

                    // Add more buttons as needed...
                }
                .padding()
                .background(Color(UIColor.systemGray6))
            }
            .navigationBarTitle("Dashboard", displayMode: .inline)
        }
        HStack {
            NavigationIcon(imageName: "house.fill", text: "Dashboard")
            NavigationIcon(imageName: "chart.line.uptrend.xyaxis", text: "Trading")
            NavigationIcon(imageName: "plus.circle", text: "Add wallet")
            NavigationIcon(imageName: "wallet.pass", text: "Wallets")
            NavigationIcon(imageName: "person.circle", text: "My profile")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}


struct TradingView_Previews: PreviewProvider {
    static var previews: some View {
        TradingView()
    }
}
