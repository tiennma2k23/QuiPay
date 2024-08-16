import SwiftUI

struct BuyView: View {
    @State private var amount: String = "0.5"
    @State private var cryptoVolume: String = "10000"
    let merchant: Merchant
    
    @State private var navigateToPayView: Bool = false
    
    var body: some View {
        NavigationView {
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
                    
                    Text("Buy BTC")
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
                    VStack(alignment: .leading) {
                        Text("Buy")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text("SOL")
                                .font(.title)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            TextField("Amount", text: $amount)
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.trailing)
                            
                            Text("SOL")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Price")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text("VNĐ")
                                .font(.title)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            TextField("Crypto Volume", text: $cryptoVolume)
                                .font(.title)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.trailing)
                            
                            Button(action: {
                                // Refresh action
                            }) {
                                Text("Refresh")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                .padding()
                
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                        VStack(alignment: .leading) {
                            Text(merchant.name)
                                .font(.headline)
                            
                            HStack {
                                Text("Min: 100,000.00")
                                Spacer()
                                Text("Max: 200,000.00")
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    
                    Text("I am online. Please do not include any crypto related keywords like BTC, BNB, ETH, Norva on the narration. Thanks for doing business with me.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
                NavigationLink(destination: PayView(), isActive: $navigateToPayView) {
                    Button(action: {
                        proceedAction()
                    }) {
                        Text("Proceed")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
    
    private func proceedAction() {
        guard let uuid = UserDefaults.standard.string(forKey: "uuid")
               else {
            print("UUID or Public Key not found")
            return
        }
        
        let mobileTransferURL = URL(string: "http://localhost:8484/mywallet/transfer/mobile?key=\(uuid)&mobile=0123456786&name=Test%201&amount=100000")!
        var mobileRequest = URLRequest(url: mobileTransferURL)
        mobileRequest.httpMethod = "POST"
        
        let solanaTransactionURL = URL(string: "http://localhost:9191/api/solana/transaction/send?fromPublicKey=Bfyyj59m5npE1iQF5TijFxhoigD6vxqiEzQ5RBUJmidS&toPublicKey=EfDRKA1ZWPjn2YgU9gvZCGwhkfZ2DdNFbYxMqoMGjn8p&lamports=500000000")!
        var solanaRequest = URLRequest(url: solanaTransactionURL)
        solanaRequest.httpMethod = "POST"
        solanaRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let solanaBody: [String: Any] = [
            "fromPublicKey": "Bfyyj59m5npE1iQF5TijFxhoigD6vxqiEzQ5RBUJmidS",
            "toPublicKey": "EfDRKA1ZWPjn2YgU9gvZCGwhkfZ2DdNFbYxMqoMGjn8p",
            "lamports": 500000000
        ]
        solanaRequest.httpBody = try? JSONSerialization.data(withJSONObject: solanaBody, options: [])
        
        let group = DispatchGroup()
        
        group.enter()
        URLSession.shared.dataTask(with: mobileRequest) { data, response, error in
            if let error = error {
                print("Mobile Transfer API Error: \(error)")
            } else {
                print("Mobile Transfer API Success")
            }
            group.leave()
        }.resume()
        
        group.enter()
        URLSession.shared.dataTask(with: solanaRequest) { data, response, error in
            if let error = error {
                print("Solana Transaction API Error: \(error)")
            } else {
                print("Solana Transaction API Success")
            }
            group.leave()
        }.resume()
        
        group.notify(queue: .main) {
            navigateToPayView = true
        }
    }
}

struct BuyView_Previews: PreviewProvider {
    static var previews: some View {
        BuyView(merchant: Merchant(name: "Crypto Lurd", price: 100, volume: 1.0, minAmount: 100000, maxAmount: 200000, trades: 150, successRate: 98, responseTime: "5 mins"))
    }
}
