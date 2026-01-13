import Foundation
import Combine

class GameManager: ObservableObject {
    @Published var players: [Player] = []
    @Published var rounds: [Round] = []
    @Published var maxScore: Int = 300
    @Published var firstScootPoints: Int = 25
    @Published var middleScootPoints: Int = 50
    
    // Check if player is eliminated (over max score)
    func isEliminated(_ player: Player) -> Bool {
        return totalScore(for: player) > maxScore
    }
    
    // Calculate total score for a player
    func totalScore(for player: Player) -> Int {
        let roundScores = rounds.reduce(0) { total, round in
            total + (round.scores[player.id] ?? 0)
        }
        return player.initialScore + roundScores
    }
    
    // Get the highest current score among all players, else 0
    func highestScore() -> Int {
        guard !players.isEmpty else { return 0 }
        return players.map { totalScore(for: $0) }.max() ?? 0
    }
    
    // Add a new player with the highest score or 0
    func addPlayer(name: String) {
        let initialScore = highestScore()
        let newPlayer = Player(name: name, initialScore: initialScore)
        players.append(newPlayer)
    }
    
    // Add a new round with scores
    func addRound(scores: [UUID: Int]) {
        let newRound = Round(scores: scores)
        rounds.append(newRound)
    }
    
    // Delete a player
    func deletePlayer(_ player: Player) {
        players.removeAll { $0.id == player.id }
        // Remove player from all rounds
        for i in rounds.indices {
            rounds[i].scores.removeValue(forKey: player.id)
        }
    }
    
    // Delete a round
    func deleteRound(_ round: Round) {
        rounds.removeAll { $0.id == round.id }
    }
}
