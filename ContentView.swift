import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = GameManager()
    @State private var showingAddPlayer = false
    @State private var showingAddRound = false
    @State private var showingRoundHistory = false
    @State private var showingSettings = false
    @State private var editingPlayer: Player? = nil
    @State private var showingClearAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                if gameManager.players.isEmpty {
                    VStack(spacing: 20) {
                        Text("No players yet")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Button(action: { showingAddPlayer = true }) {
                            Label("Add First Player", systemImage: "person.badge.plus")
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    // Players list
                    List {
                        ForEach(gameManager.players) { player in
                            HStack {
                                Text(player.name)
                                    .font(.headline)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(gameManager.totalScore(for: player))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(gameManager.isEliminated(player) ? .white : .blue)
                                    
                                    if gameManager.isEliminated(player) {
                                        Text("ELIMINATED")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(gameManager.isEliminated(player) ? Color.red.opacity(0.8) : Color.clear)
                            )
                            .listRowBackground(gameManager.isEliminated(player) ? Color.red.opacity(0.2) : Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                editingPlayer = player
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    gameManager.deletePlayer(player)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    editingPlayer = player
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button(action: { showingAddRound = true }) {
                            Label("Add New Round", systemImage: "plus.circle.fill")
                                .frame(maxWidth: .infinity)
                                .font(.headline)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(gameManager.players.isEmpty)
                        
                        Button(action: { showingRoundHistory = true }) {
                            Label("View Round History", systemImage: "clock.fill")
                                .frame(maxWidth: .infinity)
                                .font(.headline)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .disabled(gameManager.rounds.isEmpty)
                    }
                    .padding()
                }
            }
            .navigationTitle("Point Totals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { showingClearAlert = true }) {
                            Image(systemName: "trash.fill")
                        }
                        .disabled(gameManager.players.isEmpty && gameManager.rounds.isEmpty)
                        
                        Button(action: { showingAddPlayer = true }) {
                            Image(systemName: "person.badge.plus")
                        }
                    }
                }
            }
            .alert("Clear All Data?", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAllData()
                }
            } message: {
                Text("This will delete all players and rounds. This action cannot be undone.")
            }
            .sheet(isPresented: $showingAddPlayer) {
                AddPlayerView(gameManager: gameManager)
            }
            .sheet(isPresented: $showingAddRound) {
                AddRoundView(gameManager: gameManager)
            }
            .sheet(isPresented: $showingRoundHistory) {
                RoundHistoryView(gameManager: gameManager)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(gameManager: gameManager)
            }
            .sheet(item: $editingPlayer) { player in
                EditPlayerView(gameManager: gameManager, player: player)
            }
        }
    }
    
    private func deletePlayers(at offsets: IndexSet) {
        for index in offsets {
            let player = gameManager.players[index]
            gameManager.deletePlayer(player)
        }
    }
    
    private func clearAllData() {
        gameManager.players.removeAll()
        gameManager.rounds.removeAll()
    }
}

#Preview {
    ContentView()
}
