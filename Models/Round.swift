import Foundation

struct Round: Identifiable, Codable {
    let id: UUID
    var scores: [UUID: Int] // Player ID to score mapping
    let date: Date
    
    init(id: UUID = UUID(), scores: [UUID: Int] = [:], date: Date = Date()) {
        self.id = id
        self.scores = scores
        self.date = date
    }
}
