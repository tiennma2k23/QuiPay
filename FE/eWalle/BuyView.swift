import SwiftUI

struct BuyView: View {
    @State private var amount: String = "100,000"
    @State private var cryptoVolume: String = "0.00235 BTC"
    
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
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Nigeria Naira")
                            .font(.title)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        TextField("Amount", text: $amount)
                            .font(.title)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.trailing)
                        
                        Text("NGN")
                            .foregroundColor(.gray)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Crypto Volume")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Bitcoin")
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
                        Text("Crypto Lurd")
                            .font(.headline)
                        
                        Text("20,000,000")
                            .foregroundColor(.gray)
                        
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
            
            Button(action: {
                // Proceed action
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
        .padding()
    }
}

struct BuyView_Previews: PreviewProvider {
    static var previews: some View {
        BuyView()
    }
}
