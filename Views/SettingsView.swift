import SwiftUI

struct SettingsView: View {
    @ObservedObject var gameManager: GameManager
    @Environment(\.dismiss) var dismiss
    
    @State private var maxScoreText: String = ""
    @State private var firstScootPointsText: String = ""
    @State private var middleScootPointsText: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Game Rules")) {
                    HStack {
                        Text("Maximum Score")
                        Spacer()
                        TextField("Score", text: $maxScoreText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("First Scoot Points")
                        Spacer()
                        TextField("Points", text: $firstScootPointsText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Middle Scoot Points")
                        Spacer()
                        TextField("Points", text: $middleScootPointsText)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                Section(header: Text("Current Status")) {
                    HStack {
                        Text("Active Players")
                        Spacer()
                        Text("\(gameManager.players.filter { !gameManager.isEliminated($0) }.count)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("Eliminated Players")
                        Spacer()
                        Text("\(gameManager.players.filter { gameManager.isEliminated($0) }.count)")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSettings()
                    }
                    .disabled(!isValid())
                }
            }
            .onAppear {
                maxScoreText = "\(gameManager.maxScore)"
                firstScootPointsText = "\(gameManager.firstScootPoints)"
                middleScootPointsText = "\(gameManager.middleScootPoints)"
            }
        }
    }
    
    private func isValid() -> Bool {
        guard let score = Int(maxScoreText), score > 0,
              let firstScoot = Int(firstScootPointsText), firstScoot > 0,
              let middleScoot = Int(middleScootPointsText), middleScoot > 0 else {
            return false
        }
        return true
    }
    
    private func saveSettings() {
        if let score = Int(maxScoreText), score > 0,
           let firstScoot = Int(firstScootPointsText), firstScoot > 0,
           let middleScoot = Int(middleScootPointsText), middleScoot > 0 {
            gameManager.maxScore = score
            gameManager.firstScootPoints = firstScoot
            gameManager.middleScootPoints = middleScoot
            dismiss()
        }
    }
}

#Preview {
    SettingsView(gameManager: GameManager())
}
