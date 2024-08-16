import SwiftUI

struct PhoneCardPurchaseView: View {
    @State private var selectedCard: String = ""
    @State private var selectedPrice: String = ""
    @State private var pinCode: String = ""
    @State private var showPinEntry: Bool = false
    @State private var showLoading: Bool = false
    @State private var showSuccess: Bool = false
    @State private var paymentMethods: [String] = []
    @State private var paymentMethod: String = ""
    @State private var cardInfo: String = "" // Thông tin thẻ nạp điện thoại
    @State private var cardSerial: String = "" // Serial của thẻ
    @State private var cardMST: String = "" // MST của thẻ
    @State private var topupCompleted: Bool = false // Biến điều khiển việc hoàn tất top-up

    let networks = ["Viettel", "Mobifone", "Vinaphone"]
    let amounts = [
        ("10.000đ", 0.1, 0.005),
        ("20.000đ", 0.2, 0.01),
        ("50.000đ", 0.5, 0.025),
        ("100.000đ", 1, 0.05),
        ("200.000đ", 2, 0.1),
        ("500.000đ", 5, 0.3)
    ]

    var body: some View {
        NavigationView {
            if topupCompleted {
                VStack {
                    Text("Quá trình nạp thẻ đã hoàn tất.")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding()
                    Button("Quay lại") {
                        topupCompleted = false
                        // Reset các trạng thái để chuẩn bị cho lần nạp thẻ tiếp theo
                        resetTopup()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        // Chọn loại thẻ
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Chọn loại thẻ")
                                .font(.headline)
                                .padding(.leading, 5)

                            Picker("Chọn loại thẻ", selection: $selectedCard) {
                                ForEach(networks, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)

                        // Chọn mệnh giá và hiển thị giá trị ước tính
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Chọn mệnh giá")
                                .font(.headline)
                                .padding(.leading, 5)

                            VStack(spacing: 10) {
                                ForEach(amounts, id: \.0) { amount, coinValue, refund in
                                    Button(action: {
                                        selectedPrice = amount
                                    }) {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text(amount)
                                                    .foregroundColor(.primary)
                                                Text("Ước tính: \(coinValue, specifier: "%.2f") SOL")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                Text("Hoàn lại: \(refund, specifier: "%.2f") SOL")
                                                    .font(.subheadline)
                                                    .foregroundColor(.green)
                                            }
                                            Spacer()
                                            if selectedPrice == amount {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding()
                                        .background(Color(UIColor.systemGray6))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)

                        // Chọn kênh thanh toán
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Chọn kênh thanh toán")
                                .font(.headline)
                                .padding(.leading, 5)

                            Picker("Chọn kênh thanh toán", selection: $paymentMethod) {
                                ForEach(paymentMethods, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 5)

                        Spacer()

                        // Nút xác nhận giao dịch
                        Button(action: {
                            showPinEntry = true
                        }) {
                            Text("Xác nhận giao dịch")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(15)
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color(UIColor.systemGroupedBackground))
                    .onAppear {
                        fetchPaymentMethods()
                    }
                }
                .navigationTitle("Mua thẻ điện thoại")
            }
        }
        .overlay(
            // Hiển thị SecurePinEntryView khi người dùng bấm "Xác nhận giao dịch"
            showPinEntry ? SecurePinEntryView(pinCode: $pinCode, showLoading: $showLoading, showPinEntry: $showPinEntry, showSuccess: $showSuccess, cardInfo: $cardInfo, cardSerial: $cardSerial, cardMST: $cardMST, selectedCard: $selectedCard, selectedPrice: $selectedPrice, performTransaction: performTransaction) : nil
        )
        .overlay(
            // Hiển thị màn hình chờ sau khi nhập mã PIN thành công
            showLoading ? LoadingView() : nil
        )
        .alert(isPresented: $showSuccess) {
            Alert(
                title: Text("Xử lý thành công"),
                message: Text("Thông tin thẻ:\n\(cardInfo)\nSerial: \(cardSerial)\nMST: \(cardMST)"),
                primaryButton: .default(Text("Sao chép")) {
                    let cardDetails = "Thông tin thẻ:\n\(cardInfo)\nSerial: \(cardSerial)\nMST: \(cardMST)"
                    UIPasteboard.general.string = cardDetails
                },
                secondaryButton: .default(Text("Gọi điện")) {
                    // Mở ứng dụng gọi điện với số cần thiết
                    if let phoneURL = URL(string: "tel://*100*123456789#") {
                        UIApplication.shared.open(phoneURL)
                    }
                }
            )
        }
        .onChange(of: showSuccess) { newValue in
            if newValue {
                // Khi thông báo thành công được hiển thị, cập nhật biến topupCompleted
                topupCompleted = true
                // Đặt lại các biến cần thiết
                resetTopup()
            }
        }
    }

    func fetchPaymentMethods() {
        guard let url = URL(string: "http://localhost:8484/customer/bankaccount/getall?key=T2HXrZ") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        var fetchedMethods: [String] = []
                        for account in jsonResponse {
                            if let wallet = account["wallet"] as? [String: Any],
                               let customer = wallet["customer"] as? [String: Any],
                               let customerName = customer["customerName"] as? String,
                               customerName == "Test1",
                               let accountNo = account["accountNo"] as? String {
                                fetchedMethods.append(accountNo)
                            }
                        }
                        DispatchQueue.main.async {
                            paymentMethods = fetchedMethods
                            if !fetchedMethods.isEmpty {
                                paymentMethod = fetchedMethods[0] // Set default payment method if available
                            }
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error)")
                }
            }
        }
        task.resume()
    }

    func performTransaction() {
        guard let selectedAmount = amounts.first(where: { $0.0 == selectedPrice }) else { return }
        let (amount, coinValue, refund) = selectedAmount
        let lamports = (coinValue - refund) * 1_000_000_000

        let url = URL(string: "http://localhost:9191/api/solana/transaction/send?fromPublicKey=28uED4ALwzUTpuDNSwBPg47Q2kYStf2zyuaBrWpo5NYi&toPublicKey=B3cFTKziCQVHv1KbeyEZugSMxzkEhBMCFq1o2TrEG2Ct&lamports=\(Int(lamports))")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "fromPublicKey": "4ZXhSWMmrFJ2rfVawEZZTgto5yVtVdkNf51ursFm1B9z",
            "toPublicKey": "5BSpLTyWvjcEMUy2X3mLYz2yCWggzPwcTnHWKQTfLsct",
            "lamports": Int(lamports)
        ], options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                showLoading = false
                if let error = error {
                    print("Transaction failed: \(error)")
                    showSuccess = false
                } else {
                    // Update thông tin thẻ
                    cardInfo = "Loại thẻ: \(selectedCard), Mệnh giá: \(selectedPrice)"
                    cardSerial = "0123456789" // Cập nhật thông tin thực tế
                    cardMST = "01234567789" // Cập nhật thông tin thực tế
                    showSuccess = true
                }
            }
        }
        task.resume()
    }

    func resetTopup() {
        // Đặt lại các biến để chuẩn bị cho lần nạp thẻ tiếp theo
        selectedCard = ""
        selectedPrice = ""
        pinCode = ""
        paymentMethod = ""
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Đang xử lý...")
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5, anchor: .center)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SecurePinEntryView: View {
    @Binding var pinCode: String
    @Binding var showLoading: Bool
    @Binding var showPinEntry: Bool
    @Binding var showSuccess: Bool
    @Binding var cardInfo: String
    @Binding var cardSerial: String
    @Binding var cardMST: String
    @Binding var selectedCard: String
    @Binding var selectedPrice: String
    var performTransaction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Nhập mã PIN")
                .font(.title)
                .fontWeight(.bold)

            SecureField("****", text: $pinCode)
                .keyboardType(.numberPad)
                .frame(width: 100, height: 50)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

            Button(action: {
                if pinCode.count == 4 {
                    showLoading = true
                    // Giả lập thời gian chờ 2 giây trước khi thông báo thành công
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        performTransaction()
                        showPinEntry = false
                    }
                }
            }) {
                Text("Xác nhận")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(pinCode.count == 4 ? Color.blue : Color.gray)
                    .cornerRadius(15)
            }
            .disabled(pinCode.count != 4)
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
        .padding()
    }
}

struct PhoneCardPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneCardPurchaseView()
    }
}
