import SwiftUI

struct AddPlayerView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    
    @State private var playerName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Details")) {
                    TextField("Player Name", text: $playerName)
                        .textInputAutocapitalization(.words)
                }
                
                if !gameManager.players.isEmpty {
                    Section(header: Text("Starting Score")) {
                        HStack {
                            Text("Will start with:")
                            Spacer()
                            Text("\(gameManager.highestScore()) points")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    Section {
                        Text("New players start with the highest current score among all players.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Add Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addPlayer()
                    }
                    .disabled(playerName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func addPlayer() {
        let trimmedName = playerName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        gameManager.addPlayer(name: trimmedName)
        dismiss()
    }
}

#Preview {
    AddPlayerView(gameManager: GameManager())
}
