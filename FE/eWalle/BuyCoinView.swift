import SwiftUI

struct BuyCoinView: View {
    @State private var amount: String = ""
    private let currentBalance: Int = 10000
    private let minAmount: Int = 100
    private let maxAmount: Int = 1000000
    
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
            
            Text("Min ₹\(minAmount) - Max ₹\(maxAmount)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Text("Current Balance: \(currentBalance)")
                .font(.headline)
                .padding(.top, 10)
            
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    ForEach([0, 10, 25], id: \.self) { percentage in
                        Button(action: {
                            let calculatedAmount = currentBalance * percentage / 100
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
                            let calculatedAmount = currentBalance * percentage / 100
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
    }
}

struct BuyCoinView_Previews: PreviewProvider {
    static var previews: some View {
        BuyCoinView()
    }
}
