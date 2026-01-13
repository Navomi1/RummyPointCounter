import SwiftUI

struct RoundHistoryView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Array(gameManager.rounds.enumerated()), id: \.element.id) { index, round in
                    Section(header: Text("Round \(index + 1)")) {
                        ForEach(gameManager.players) { player in
                            HStack {
                                Text(player.name)
                                Spacer()
                                if let score = round.scores[player.id] {
                                    Text("\(score)")
                                        .fontWeight(.semibold)
                                        .foregroundColor(.blue)
                                } else {
                                    Text("—")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        Text(formatDate(round.date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteRounds)
            }
            .navigationTitle("Round History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func deleteRounds(at offsets: IndexSet) {
        for index in offsets {
            let round = gameManager.rounds[index]
            gameManager.deleteRound(round)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    let manager = GameManager()
    let player1 = Player(name: "Alice", initialScore: 0)
    let player2 = Player(name: "Bob", initialScore: 0)
    manager.players = [player1, player2]
    manager.rounds = [
        Round(scores: [player1.id: 10, player2.id: 15]),
        Round(scores: [player1.id: 20, player2.id: 5])
    ]
    return RoundHistoryView(gameManager: manager)
}
