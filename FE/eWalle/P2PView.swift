import SwiftUI

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

struct P2PView: View {
    let merchants = [
        Merchant(name: "Crypto Lurd", price: 20000000.00, volume: 0.0212, minAmount: 100000, maxAmount: 500000, trades: 150, successRate: 98, responseTime: "5 mins"),
        Merchant(name: "Crypto Lurd", price: 19996989.75, volume: 0.0212, minAmount: 100000, maxAmount: 500000, trades: 150, successRate: 98, responseTime: "5 mins"),
        Merchant(name: "Crypto Lurd", price: 19996987.95, volume: 0.0212, minAmount: 100000, maxAmount: 500000, trades: 150, successRate: 98, responseTime: "5 mins"),
        Merchant(name: "Crypto Lurd", price: 19996999.85, volume: 0.0212, minAmount: 100000, maxAmount: 500000, trades: 150, successRate: 98, responseTime: "5 mins"),
        Merchant(name: "Crypto Lurd", price: 19997900.50, volume: 0.0212, minAmount: 100000, maxAmount: 500000, trades: 150, successRate: 98, responseTime: "5 mins")
    ]
    
    @State private var selectedCurrency = "NGN"
    @State private var selectedCrypto = "BTC"
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Back action
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                }
                Spacer()
                Text("P2P")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Placeholder for alignment
                }) {
                    Image(systemName: "chevron.left")
                        .hidden()
                        .padding()
                }
            }
            
            HStack {
                TextField("Enter Amount", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Picker(selection: $selectedCurrency, label: Text("")) {
                    Text("NGN").tag("NGN")
                    Text("USD").tag("USD")
                    // Add more currency options here
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Picker(selection: $selectedCrypto, label: Text("")) {
                    Text("BTC").tag("BTC")
                    Text("ETH").tag("ETH")
                    // Add more crypto options here
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Button(action: {
                    // Filter action
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
            }
            .padding()
            
            List(merchants) { merchant in
                MerchantRow(merchant: merchant)
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
                Button(action: {
                    // Buy action
                }) {
                    Text("Buy")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
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

struct P2PView_Previews: PreviewProvider {
    static var previews: some View {
        P2PView()
    }
}
