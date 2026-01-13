import SwiftUI

struct EditPlayerView: View {
    @ObservedObject var gameManager: GameManager
    let player: Player
    @Environment(\.dismiss) var dismiss
    
    @State private var playerName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Details")) {
                    TextField("Player Name", text: $playerName)
                        .textInputAutocapitalization(.words)
                }
                
                Section(header: Text("Current Score")) {
                    HStack {
                        Text("Total Score:")
                        Spacer()
                        Text("\(gameManager.totalScore(for: player))")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    if gameManager.isEliminated(player) {
                        HStack {
                            Text("Status:")
                            Spacer()
                            Text("ELIMINATED")
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Edit Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePlayer()
                    }
                    .disabled(playerName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                playerName = player.name
            }
        }
    }
    
    private func savePlayer() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        if let index = gameManager.players.firstIndex(where: { $0.id == player.id }) {
            gameManager.players[index].name = trimmedName
        }
        dismiss()
    }
}

#Preview {
    let manager = GameManager()
    let player = Player(name: "Alice", initialScore: 0)
    manager.players = [player]
    return EditPlayerView(gameManager: manager, player: player)
}
