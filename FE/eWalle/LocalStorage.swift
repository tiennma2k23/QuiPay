import Foundation

class LocalStorage {
    static let shared = LocalStorage()
    private init() {}
    
    private let fileName = "userData.json"
    
    struct UserData: Codable {
        let uuid: String
        let phoneNumber: String
    }
    
    func save(userData: UserData) {
        do {
            let data = try JSONEncoder().encode(userData)
            let url = getFilePath()
            try data.write(to: url)
        } catch {
            print("Error saving user data: \(error.localizedDescription)")
        }
    }
    
    func load() -> UserData? {
        do {
            let url = getFilePath()
            let data = try Data(contentsOf: url)
            let userData = try JSONDecoder().decode(UserData.self, from: data)
            return userData
        } catch {
            print("Error loading user data: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func getFilePath() -> URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
}
