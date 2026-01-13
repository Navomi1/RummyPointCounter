import SwiftUI

struct AddRoundView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    
    @State private var scores: [UUID: String] = [:]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter scores for this round")) {
                    ForEach(gameManager.players.filter { !gameManager.isEliminated($0) }) { player in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(player.name)
                                .font(.headline)
                            
                            HStack(spacing: 8) {
                                TextField("Score", text: binding(for: player.id))
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button("Scoot") {
                                    scores[player.id] = "\(gameManager.firstScootPoints)"
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                                
                                Button("Middle") {
                                    scores[player.id] = "\(gameManager.middleScootPoints)"
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                Section {
                    Text("Enter the points each player scored in this round.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if gameManager.players.filter({ gameManager.isEliminated($0) }).count > 0 {
                        Text("Eliminated players are not included in new rounds.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("New Round")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRound()
                    }
                    .disabled(!isValid())
                }
            }
            .onAppear {
                // Initialize scores dictionary
                for player in gameManager.players {
                    scores[player.id] = ""
                }
            }
        }
    }
    
    private func binding(for playerId: UUID) -> Binding<String> {
        Binding(
            get: { scores[playerId] ?? "" },
            set: { scores[playerId] = $0 }
        )
    }
    
    private func isValid() -> Bool {
        // Check if all players have a valid score entered
        for player in gameManager.players {
            guard let scoreText = scores[player.id],
                  !scoreText.isEmpty,
                  Int(scoreText) != nil else {
                return false
            }
        }
        return true
    }
    
    private func saveRound() {
        var roundScores: [UUID: Int] = [:]
        
        for player in gameManager.players {
            if let scoreText = scores[player.id],
               let score = Int(scoreText) {
                roundScores[player.id] = score
            }
        }
        
        gameManager.addRound(scores: roundScores)
        dismiss()
    }
}

#Preview {
    let manager = GameManager()
    manager.players = [
        Player(name: "Alice", initialScore: 0),
        Player(name: "Bob", initialScore: 0)
    ]
    return AddRoundView(gameManager: manager)
}
