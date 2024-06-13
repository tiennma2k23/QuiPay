import SwiftUI

// Define CoinData1 struct to represent data received from the API
struct CoinData1: Decodable {
    let symbol: String
    let lastPrice: String
    let priceChangePercent: String?
}

struct Coin: Identifiable {
    let id = UUID()
    let name: String
    let symbol: String
    let price: String
    let change: String
    let isPositive: Bool
}

class CoinViewModel: ObservableObject {
    @Published var coins: [Coin] = []
    @Published var searchText: String = ""
    
    var filteredCoins: [Coin] {
        if searchText.isEmpty {
            return coins
        } else {
            return coins.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    init() {
        fetchCoins()
        // Adding some sample coins for demonstration
        addSampleCoins()
    }

    func fetchCoins() {
        guard let url = URL(string: "https://api.binance.com/api/v3/ticker/24hr") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let coinData1 = try JSONDecoder().decode([CoinData1].self, from: data)
                
                DispatchQueue.main.async {
                    self.coins = coinData1.map { data in
                        let change = data.priceChangePercent ?? "0.0%"
                        let changeDouble = Double(change.replacingOccurrences(of: "%", with: "")) ?? 0.0
                        let isPositive = changeDouble > 0

                        return Coin(
                            name: data.symbol,
                            symbol: data.symbol,
                            price: data.lastPrice,
                            change: String(format: "%.2f%%", changeDouble),
                            isPositive: isPositive
                        )
                    }
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func addSampleCoins() {
        let sampleCoins = [
            Coin(name: "Bitcoin", symbol: "BTC", price: "28000", change: "-9.4%", isPositive: false),
            Coin(name: "Ethereum", symbol: "ETH", price: "1900", change: "-9.7%", isPositive: false),
            Coin(name: "Tether", symbol: "USDT", price: "1", change: "-0.2%", isPositive: false),
            Coin(name: "Binance Coin", symbol: "BNB", price: "280", change: "-5.7%", isPositive: false),
            Coin(name: "USD Coin", symbol: "USDC", price: "1", change: "-0.1%", isPositive: false),
            Coin(name: "XRP", symbol: "XRP", price: "0.58", change: "0.5%", isPositive: true),
            Coin(name: "Cardano", symbol: "ADA", price: "1.25", change: "1.2%", isPositive: true),
            Coin(name: "Dogecoin", symbol: "DOGE", price: "0.25", change: "2.3%", isPositive: true)
        ]
        
        self.coins.append(contentsOf: sampleCoins)
    }
}

struct MarketCoinView: View {
    @ObservedObject var viewModel = CoinViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "sun.max")
                    Text("Markets")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding()

                SearchBar(text: $viewModel.searchText)

                List(viewModel.filteredCoins) { coin in
                    CoinRowView(coin: coin)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct CoinRowView: View {
    let coin: Coin

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(coin.name)
                    .font(.headline)
                Text("Price: \(coin.price)")
                Text("Change: \(coin.change)")
                    .foregroundColor(coin.isPositive ? .green : .red)
            }
            Spacer()
            Image(systemName: coin.isPositive ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")
        }
        .padding()
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search Coins"
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct MarketCoinView_Previews: PreviewProvider {
    static var previews: some View {
        MarketCoinView()
    }
}
