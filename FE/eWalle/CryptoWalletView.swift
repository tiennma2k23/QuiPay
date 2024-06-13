import SwiftUI

struct CryptoWalletView: View {
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
                    Text("£ 2,089.95 GBP")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                    HStack {
                        Text("+7.50%")
                            .foregroundColor(.green)
                        Text("+£6,05.10")
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
                    ForEach(coinsData) { coinData in
                        CoinRow(coinData: coinData)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .background(Color.black)
            .navigationBarHidden(true)
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

struct ActionButtonData: Identifiable {
    var id = UUID()
    var icon: String
    var label: String
}

let actionButtonsData = [
    ActionButtonData(icon: "plus", label: "Buy"),
    ActionButtonData(icon: "minus", label: "Sell"),
    ActionButtonData(icon: "bag", label: "P2P"),
    ActionButtonData(icon: "arrow.left.arrow.right", label: "Transfer"),
    ActionButtonData(icon: "handshake", label: "Trade")
]

struct CoinData: Identifiable {
    var id = UUID()
    var name: String
    var amount: String
    var value: String
    var change: String
    var changeColor: Color
}

let coinsData = [
    CoinData(name: "Moti", amount: "107,969,98 MOTI", value: "£1,939.74", change: "-0.01%", changeColor: .red),
    CoinData(name: "USD Coin", amount: "3,343,004,26 USD", value: "£1,939.74", change: "+6.03%", changeColor: .green),
    CoinData(name: "Paris Saint-Germain Fa.", amount: "1,289,603 PSG", value: "£1,939.74", change: "+0.09%", changeColor: .green),
    CoinData(name: "Bitcoin", amount: "0.191138 BTC", value: "£1,939.74", change: "--", changeColor: .gray),
    CoinData(name: "Ethereum", amount: "116.74", value: "£1,939.74", change: "+0.20%", changeColor: .red),
    CoinData(name: "Tether", amount: "107,969,98 USD", value: "£1,939.74", change: "--", changeColor: .gray),
    CoinData(name: "Binance Coin", amount: "0 USD", value: "£0.00", change: "--", changeColor: .gray),
    CoinData(name: "Ripple", amount: "0 XPR", value: "£0.00", change: "--", changeColor: .gray)
]
