import SwiftUI

struct PayView: View {
    @State private var amount: String = "100,000"
    @State private var accountName: String = "Ademola Michael"
    @State private var accountNumber: String = "0000000000"
    @State private var transferID: String = "EA1991111"
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Add back button action here
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Spacer()
                
                Text("PAY")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Placeholder for alignment
                Image(systemName: "chevron.left")
                    .opacity(0)
                    .padding()
            }
            .padding(.top, 10)
            
            VStack(spacing: 20) {
                HStack {
                    Spacer()
                    
                    Text("₦\(amount)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Button(action: {
                        // Copy amount action
                    }) {
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.black)
                            .padding(.leading, 5)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("• Proceed to your bank app or payment platform and send the required amount to the bank account details below.")
                    
                    Text("• After completing the payment, come back to the Norva app and click confirm payment to notify the seller")
                }
                .font(.subheadline)
                .foregroundColor(.black)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Account Name")
                        Spacer()
                        Text(accountName)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Account Number")
                        Spacer()
                        Text(accountNumber)
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("Transfer ID")
                        Spacer()
                        Text(transferID)
                            .fontWeight(.bold)
                    }
                }
                .font(.headline)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text("Important")
                        .font(.headline)
                        .foregroundColor(.red)
                    
                    Text("Please do not include any crypto related keyword like BTC, BNB, ETH, USDT, Norva etc. on the narration when making payment")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            }
            .padding()
            
            Spacer()
            
            // Simple spinning activity indicator
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
            
            Spacer()
        }
        .padding()
    }
}

struct PayView_Previews: PreviewProvider {
    static var previews: some View {
        PayView()
    }
}
