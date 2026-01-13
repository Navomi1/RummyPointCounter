import Foundation

struct Player: Identifiable, Codable {
    let id: UUID
    var name: String
    var initialScore: Int
    
    init(id: UUID = UUID(), name: String, initialScore: Int = 0) {
        self.id = id
        self.name = name
        self.initialScore = initialScore
    }
}
