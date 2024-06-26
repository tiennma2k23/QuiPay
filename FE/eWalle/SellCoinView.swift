import SwiftUI

struct SellCoinView: View {
    @State private var amount: String = ""
    @State private var currentBalance: Double = 0.0 // Update to Double to match the saved balance type
    private let minAmount: Int = 0
    private let maxAmount: Int = 100
    
    var body: some View {
        VStack {
            HStack {
                Text("Sell Bitcoin")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    // Action for sell button
                }) {
                    Text("BUY BTC")
                        .foregroundColor(.red)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 2)
                        )
                }
            }
            .padding()
            
            Spacer()
            
            Text("Enter Amount in INR")
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
            
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    ForEach([0, 10, 25], id: \.self) { percentage in
                        Button(action: {
                            let calculatedAmount = currentBalance * Double(percentage) / 100
                            amount = "\(calculatedAmount)"
                        }) {
                            Text("\(percentage) %")
                                .padding()
                                .frame(minWidth: 50)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    ForEach([50, 75, 100], id: \.self) { percentage in
                        Button(action: {
                            let calculatedAmount = currentBalance * Double(percentage) / 100
                            amount = "\(calculatedAmount)"
                        }) {
                            Text("\(percentage) %")
                                .padding()
                                .frame(minWidth: 50)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            Button(action: {
                // Action for preview Sell button
            }) {
                Text("PREVIEW SELL")
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

struct SellCoinView_Previews: PreviewProvider {
    static var previews: some View {
        SellCoinView()
    }
}
