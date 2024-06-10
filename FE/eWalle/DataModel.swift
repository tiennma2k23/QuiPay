
import Foundation

struct Transaction: Identifiable {
    var id = UUID()
    var date: Date
    var wallet: WalletType
    var type: TransactionType
    var amount: Double
    var currency: String
    var isIncome: Bool
}

enum WalletType: String, CaseIterable {
    case bitcoin = "Bitcoin"
    case paypal = "PayPal"
    case visa = "Visa"
    case mastercard = "Mastercard"
}

enum TransactionType: String, CaseIterable {
    case salary = "Salary"
    case storePayment = "Store payment"
    case exchangeTrading = "Exchange Trading"
    case gasoline = "Gasoline"
    case phone = "Phone"
    // Add more transaction types as needed
}

struct Wallet: Identifiable {
    var id = UUID()
    var type: WalletType
    var balance: Double
    var currency: String
}
