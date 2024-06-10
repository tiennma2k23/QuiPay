import Foundation

let sampleTransactions: [Transaction] = [
    Transaction(date: Date(), wallet: .bitcoin, type: .exchangeTrading, amount: 0.0017, currency: "BTC", isIncome: true),
    Transaction(date: Date(), wallet: .paypal, type: .storePayment, amount: -22.17, currency: "USD", isIncome: false),
    Transaction(date: Date(), wallet: .visa, type: .salary, amount: 2600.50, currency: "USD", isIncome: true),
    Transaction(date: Date(), wallet: .bitcoin, type: .exchangeTrading, amount: 0.0022, currency: "BTC", isIncome: true),
    Transaction(date: Date(), wallet: .visa, type: .gasoline, amount: -29.15, currency: "USD", isIncome: false),
    Transaction(date: Date(), wallet: .mastercard, type: .storePayment, amount: -50.40, currency: "USD", isIncome: false)
]

let sampleWallets: [Wallet] = [
    Wallet(type: .bitcoin, balance: 1.2345, currency: "BTC"),
    Wallet(type: .paypal, balance: 1200.00, currency: "USD"),
    Wallet(type: .visa, balance: 5000.00, currency: "USD"),
    Wallet(type: .mastercard, balance: 3000.00, currency: "USD")
]
