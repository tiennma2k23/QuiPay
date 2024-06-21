import SwiftUI

struct SuccessSendView: View {
    var body: some View {
        VStack {
            // Green Success Header
            VStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                Text("Success")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.green)
            
            // Details Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Receiver")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Nguyễn Văn A")
                }
                HStack {
                    Text("Phone number")
                        .fontWeight(.bold)
                    Spacer()
                    Text("093 4465 088")
                }
                HStack {
                    Text("Message")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Tớ gửi tiền nhé")
                }
                HStack {
                    Text("Time")
                        .fontWeight(.bold)
                    Spacer()
                    Text("24/12/2019, 10:12")
                }
                HStack {
                    Text("Transfer code")
                        .fontWeight(.bold)
                    Spacer()
                    HStack {
                        Text("4VVG1JK3")
                        Spacer()
                        Link("Details", destination: URL(string: "https://example.com")!)
                    }
                }
                HStack {
                    Text("Total Money")
                        .fontWeight(.bold)
                    Spacer()
                    Text("-100.000")
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding()

            // Contact CS and Rating Section
            VStack {
                Text("Need help? Contact CS")
                    .foregroundColor(.blue)
                HStack {
                    ForEach(0..<5) { _ in
                        Image(systemName: "star")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            
            // Buttons
            HStack {
                Button(action: {
                    // Action for new transaction
                }) {
                    Text("New transaction")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Button(action: {
                    // Action for homepage
                }) {
                    Text("Homepage")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.top)
    }
}

struct SuccessSendView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessSendView()
    }
}
