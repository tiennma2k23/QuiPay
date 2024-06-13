import SwiftUI
import Charts

struct TradingView: View {
    @State private var price: Double = 0.0
    @State private var priceChange: Double = 0.0
    @State private var isPositive: Bool = true
    @State private var priceData: [PricePoint] = []
    @State private var selectedInterval: TimeInterval = .oneMinute
    let cryptoService = CryptoService()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Bitcoin (BTC)")
                        .font(.title)
                        .padding()
                    Spacer()
                    Button(action: {
                        // Action for Exchange button
                    }) {
                        Text("Exchange")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                
                Text("U\(price, specifier: "%.2f")")
                    .font(.largeTitle)
                    .padding()
                
                Text("\(isPositive ? "+" : "") \(priceChange, specifier: "%.3f") (\(priceChange / price * 100, specifier: "%.2f")%)")
                    .foregroundColor(isPositive ? .green : .red)
                    .padding()
                
                Picker("Interval", selection: $selectedInterval) {
                    ForEach(TimeInterval.allCases, id: \.self) { interval in
                        Text(interval.displayName).tag(interval)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if !priceData.isEmpty {
                    LineChartView(priceData: priceData)
                        .frame(height: 300)
                        .padding()
                } else {
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 300)
                        .padding()
                }
                
                HStack {
                    Button(action: {
                        // Action for Buy button
                    }) {
                        Text("BUY")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action for Sell button
                    }) {
                        Text("SELL")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            cryptoService.startFetchingRealTimePrice()
            cryptoService.priceUpdateHandler = { newPrice in
                if let newPrice = newPrice {
                    self.priceChange = newPrice - self.price
                    self.isPositive = self.priceChange >= 0
                    self.price = newPrice
                }
            }
            fetchData()
        }
        .onDisappear {
            cryptoService.stopFetchingRealTimePrice()
        }
        .onChange(of: selectedInterval) { _ in
            fetchData()
        }
    }
    
    func fetchData() {
        cryptoService.fetchBitcoinPriceHistory(interval: selectedInterval) { newPriceData in
            self.priceData = newPriceData
        }
    }
}

struct LineChartView: View {
    var priceData: [PricePoint]

    var body: some View {
        Chart {
            ForEach(priceData) { point in
                LineMark(
                    x: .value("Time", point.time),
                    y: .value("Price", point.price)
                )
            }
        }
    }
}

struct PricePoint: Identifiable {
    var id = UUID()
    var time: Date
    var price: Double
}

extension TimeInterval: Identifiable, CaseIterable {
    public var id: Self { self }
    
    public static var allCases: [TimeInterval] {
        return [.oneSecond, .oneMinute, .fiveMinutes, .oneHour, .twelveHours, .twentyFourHours]
    }

    public var displayName: String {
        switch self {
        case .oneSecond: return "1s"
        case .oneMinute: return "1m"
        case .fiveMinutes: return "5m"
        case .oneHour: return "1h"
        case .twelveHours: return "12h"
        case .twentyFourHours: return "24h"
        default: return "\(self)"
        }
    }

    public static var oneSecond: TimeInterval { return 1 }
    public static var oneMinute: TimeInterval { return 60 }
    public static var fiveMinutes: TimeInterval { return 5 * 60 }
    public static var oneHour: TimeInterval { return 60 * 60 }
    public static var twelveHours: TimeInterval { return 12 * 60 * 60 }
    public static var twentyFourHours: TimeInterval { return 24 * 60 * 60 }
}

struct TradingView_Previews: PreviewProvider {
    static var previews: some View {
        TradingView()
    }
}
