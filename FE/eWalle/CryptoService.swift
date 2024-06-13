import Foundation

class CryptoService {
    private var timer: Timer?
    var priceUpdateHandler: ((Double?) -> Void)?
    
    func startFetchingRealTimePrice() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.fetchBitcoinPrice { newPrice in
                DispatchQueue.main.async {
                    self.priceUpdateHandler?(newPrice)
                }
            }
        }
    }
    
    func stopFetchingRealTimePrice() {
        timer?.invalidate()
        timer = nil
    }

    func fetchBitcoinPrice(completion: @escaping (Double?) -> Void) {
        let url = URL(string: "https://api.binance.com/api/v3/ticker/price?symbol=BTCUSDT")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let priceString = json["price"] as? String,
                   let price = Double(priceString) {
                    completion(price)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    func fetchBitcoinPriceHistory(interval: TimeInterval, completion: @escaping ([PricePoint]) -> Void) {
        let intervalString = mapIntervalToString(interval)
        let url = URL(string: "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=\(intervalString)&limit=100")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] {
                    var priceData: [PricePoint] = []
                    for item in jsonArray {
                        if let time = item[0] as? TimeInterval,
                           let openPriceString = item[1] as? String,
                           let openPrice = Double(openPriceString) {
                            let date = Date(timeIntervalSince1970: time / 1000)
                            let pricePoint = PricePoint(time: date, price: openPrice)
                            priceData.append(pricePoint)
                        }
                    }
                    DispatchQueue.main.async {
                        completion(priceData)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion([])
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }.resume()
    }

    private func mapIntervalToString(_ interval: TimeInterval) -> String {
        switch interval {
        case .oneSecond:
            return "1m"
        case .oneMinute:
            return "1m"
        case .fiveMinutes:
            return "5m"
        case .oneHour:
            return "1h"
        case .twelveHours:
            return "12h"
        case .twentyFourHours:
            return "1d"
        default:
            return "1m"
        }
    }
}
