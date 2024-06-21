import SwiftUI

struct BuyCoinView: View {
    @State private var amount: String = ""
    @State private var currentBalance: Double = 0.0 // Update to Double to match the saved balance type
    private let minAmount: Int = 0
    private let maxAmount: Int = 1000
    
    var body: some View {
        VStack {
            HStack {
                Text("Buy Bitcoin")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    // Action for sell button
                }) {
                    Text("SELL BTC")
                        .foregroundColor(.red)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2)
                        )
                }
            }
            .padding()
            
            Spacer()
            
            Text("Enter Amount")
                .font(.headline)
            
            TextField("0", text: $amount)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Text("Min \(minAmount) - Max \(maxAmount)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Text("Current Balance: \(currentBalance, specifier: "%.2f") SOL")
                .font(.headline)
                .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                // Action for preview buy button
            }) {
                Text("PREVIEW BUY")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
        .onAppear {
            if let savedBalance = UserDefaults.standard.value(forKey: "SOLTotalBalance") as? Double {
                self.currentBalance = savedBalance
            }
        }
    }
}

struct BuyCoinView_Previews: PreviewProvider {
    static var previews: some View {
        BuyCoinView()
    }
}
