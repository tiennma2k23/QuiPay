import SwiftUI

// Mô hình dữ liệu cho thông tin người dùng
struct User: Codable {
    let customerId: Int
    let customerName: String
    let mobileNumber: String
    let password: String
}

struct Constants {
    static let Grey: Color = Color(red: 0.42, green: 0.45, blue: 0.47)
}

struct HomeScreen: View {
    @State private var homeState = false
    @State private var homeButtonDrag = CGSize.zero
    @State private var userName: String = "MeoMeo"
    @State private var availableBalance: String = "Loading..."

    var body: some View {
        NavigationView {
            ZStack {
                HStack {
                    VStack {
                        HStack {
                            Image("Joselson")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                                .offset(x: 15, y: 15)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(userName)
                                    .fontWeight(.semibold)
                                Text("London, U.K.")
                            }
                            .offset(x: 15, y: 15)
                        }
                        .frame(width: 260, height: 155)
                        .background(Color.white)
                        .cornerRadius(40)
                        .offset(x: 30)
                        Spacer()
                    }
                    Spacer()
                }
                .offset(x: -60, y: -10)
                
                HStack {
                    VStack(alignment: .leading, spacing: 30) {
                        
                        HStack {
                            Text("Home")
                                .font(Font.custom("Avenir Next", size: 24))
                            
                            Rectangle()
                                .fill(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
                                .frame(width: 20, height: 35)
                                .offset(x: -112)
                        }
                        Text("Profile")
                            .fontWeight(.semibold)
                            .font(Font.custom("Avenir Next", size: 19))
                        Text("Accounts")
                            .fontWeight(.semibold)
                            .font(Font.custom("Avenir Next", size: 19))
                        Text("Transactions")
                            .fontWeight(.semibold)
                            .font(Font.custom("Avenir Next", size: 19))
                        Text("Stats")
                            .fontWeight(.semibold)
                            .font(Font.custom("Avenir Next", size: 19))
                        Text("Settings")
                            .fontWeight(.semibold)
                            .font(Font.custom("Avenir Next", size: 19))
                        Text("Help")
                            .fontWeight(.semibold)
                            .font(Font.custom("Avenir Next", size: 19))
                        
                        Button(action: {}) {
                            Image("logout-icon")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 33)
                            Text("Logout")
                                .foregroundColor(Color.black)
                                .font(Font.custom("Avenir Next", size: 29))
                        }
                        .offset(y: 90)
                        
                        Text("Version 2.1.0")
                            .offset(y: 140)
                    }
                    .padding(.horizontal, 30)
                    Spacer()
                }
                
                // Main content
                VStack {
                    VStack {
                        HStack {
                            Image("logo")
                                .frame(width: 44.0, height: 35.0)
                            
                            Text("QuiPay")
                                .font(.title)
                                .fontWeight(.semibold)
                            Spacer()
                            Button(action: { self.homeState.toggle() }) {
                                Image("Union")
                                    .renderingMode(.original)
                            }
                        }
                        .padding(.horizontal, 25)
                    }
                    
                    // Account Overview
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hi, \(userName)")
                                .font(
                                    Font.custom("Roboto-Bold", size: 20)
                                        .weight(.bold)
                                )
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Text("Your available balance")
                                .font(Font.custom("Roboto", size: 16))
                                .foregroundColor(Constants.Grey)
                        }
                        .padding(0)
                        Spacer()
                        Text(availableBalance)
                            .font(
                                Font.custom("IBM Plex Sans", size: 24)
                                    .weight(.semibold)
                            )
                            .foregroundColor(Color(red: 0.24, green: 0.4, blue: 0.44))
                    }
                    .padding(0)
                    .frame(width: 335.00003, alignment: .center)
                    
                    // Main Action
                    HStack(alignment: .top, spacing: 10) {
                        VStack(alignment: .center, spacing: 5) {
                            Image("Group 1024")
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Rectangle()
                                        .stroke(.white, lineWidth: 2)
                                )
                            Text("Top Up")
                                .font(
                                    Font.custom("Roboto", size: 12)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .top)
                        
                        NavigationLink(destination: PaymentConfirmationView()) {
                            VStack(alignment: .center, spacing: 6) {
                                Image("Send")
                                    .frame(width: 24, height: 24)
                                Text("Send")
                                    .font(
                                        Font.custom("Roboto", size: 12)
                                            .weight(.bold)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, alignment: .top)
                        }
                        
                        VStack(alignment: .center, spacing: 6) {
                            Image("Withdraw")
                                .frame(width: 24, height: 24)
                            Text("Withdraw")
                                .font(
                                    Font.custom("Roboto", size: 12)
                                        .weight(.bold)
                                )
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                        }
                        .padding(0)
                        .frame(maxWidth: .infinity, alignment: .top)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.14, green: 0.26, blue: 0.55))
                    .cornerRadius(10)
                    
                    // Services Section
                    VStack(alignment: .leading) {
                        HStack {
                            ServiceIcon(imageName: "globe", text: "Internet")
                            ServiceIcon(imageName: "drop", text: "Water")
                            ServiceIcon(imageName: "bolt", text: "Electricity")
                            ServiceIcon(imageName: "tv", text: "TV Cable")
                        }
                        .padding(.top)
                        
                        HStack {
                            ServiceIcon(imageName: "car", text: "Vehicle")
                            ServiceIcon(imageName: "house", text: "Rent Bill")
                            ServiceIcon(imageName: "chart.bar", text: "Invest")
                            ServiceIcon(imageName: "ellipsis", text: "More")
                        }
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    // Special Deal Section
                    VStack(alignment: .leading) {
                        Text("50% OFF")
                            .font(.headline)
                            .bold()
                        Text("Summer special deal")
                            .font(.subheadline)
                        Text("Get discount for every transaction")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical)
                    
                    // Recent Transactions Section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Recent Transaction")
                                .font(.headline)
                            Spacer()
                            Text("See All")
                                .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Image(systemName: "drop.fill")
                            VStack(alignment: .leading) {
                                Text("Water")
                                    .font(.subheadline)
                                Text("February 24, 2022")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("240.00")
                                .font(.subheadline)
                        }.padding()
                        HStack {
                            Image(systemName: "drop.fill")
                            VStack(alignment: .leading) {
                                Text("Water")
                                    .font(.subheadline)
                                Text("February 24, 2022")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("240.00")
                                .font(.subheadline)
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Bottom Navigation
                    HStack {
                        NavigationIcon(imageName: "house.fill", text: "Dashboard")
                        NavigationLink(destination: TradingView()) {
                            NavigationIcon(imageName: "chart.line.uptrend.xyaxis", text: "Trading")
                        }
                        NavigationLink(destination: AddWalletView()) {
                            NavigationIcon(imageName: "plus.circle", text: "Add wallet")
                        }
                        NavigationLink(destination: WalletsView()) {
                            NavigationIcon(imageName: "wallet.pass", text: "Wallets")
                        }
                        NavigationIcon(imageName: "person.circle", text: "My profile")
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                }
                .padding(.top, 45)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(30)
                .shadow(radius: 20)
                .rotationEffect(Angle(degrees: homeState ? -15 : 0))
                .offset(x: homeState ? 300 : 0)
                .animation(.spring())
                .gesture(DragGesture().onChanged{ value in
                    self.homeButtonDrag = value.translation
                    self.homeState = false
                })
                .animation(.easeOut)
                // .edgesIgnoringSafeArea(.all)
            }
            .frame(maxWidth: .infinity)
            .frame(maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0.9030360431, green: 0.9030360431, blue: 0.9030360431, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            self.loadUserData()
            self.loadBalance()
        }
    }
    
    // Hàm gọi API để lấy thông tin người dùng
    func loadUserData() {
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber"), let url = URL(string: "http://localhost:8484/mywallet/findaccount?phoneNumber=\(phoneNumber)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                
                DispatchQueue.main.async {
                    self.userName = user.customerName
                    self.saveUserData(user)
                }
            } catch {
                print("Error decoding user data: \(error)")
            }
        }.resume()
    }
    
    // Hàm lưu thông tin người dùng vào UserDefaults
    func saveUserData(_ user: User) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "User")
        }
    }
    
    // Hàm gọi API để lấy balance
    func loadBalance() {
        // Lấy thông tin từ UserDefaults (phoneNumber và key)
        guard let phoneNumber = UserDefaults.standard.string(forKey: "phoneNumber"),
              let key = UserDefaults.standard.string(forKey: "uuid"),
              let url = URL(string: "http://localhost:8484/mywallet/balance?mobileNumber=\(phoneNumber)&key=\(key)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            
            if let balance = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.availableBalance = balance
                }
            }
        }.resume()
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

struct ServiceIcon: View {
    var imageName: String
    var text: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Text(text)
                .font(.caption)
                .padding(.top, 5)
        }
    }
}

struct NavigationIcon: View {
    var imageName: String
    var text: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(text)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}
