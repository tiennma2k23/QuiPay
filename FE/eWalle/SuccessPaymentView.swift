import SwiftUI

struct SuccessPaymentView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "hand.thumbsup.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text("Notification has been sent to the Merchant")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                    Text("Notification Sent")
                }
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                    Text("Crypto deducted from merchant’s balance to an escrow account")
                }
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                    Text("Done")
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .padding()
            
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                VStack(alignment: .leading) {
                    Text("Test 1")
                        .font(.headline)
                    Text("Chat with agent")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "message.circle.fill")
                    .foregroundColor(.red)
                    .overlay(
                        Text("1")
                            .font(.caption)
                            .foregroundColor(.white)
                            .offset(x: 10, y: -10)
                    )
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
            .padding()
            
            Button(action: {
                // Add done action here
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
}

struct SuccessPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessPaymentView()
    }
}
