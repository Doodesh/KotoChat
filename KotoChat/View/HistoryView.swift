//
//  HistoryView.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import SwiftUI



struct HistoryView: View {
    @ObservedObject var viewModel: TextViewModel
    @State private var showingDeleteAlert = false
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm   dd.MM.yy "
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.history.isEmpty {
                    Text("История пуста")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    ForEach(Array(viewModel.history.enumerated()), id: \.offset) { index, messages in
                        if let firstMessage = messages.first {
                            NavigationLink(destination: ChatDetailView(messages: messages)) {
                                Text(dateFormatter.string(from: firstMessage.date))
                            }
                        }
                    }
                }
            }
            .background(Color("ColorB"))
            .scrollContentBackground(.hidden)
            .navigationTitle("История чатов")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                    }
                    .disabled(viewModel.history.isEmpty)
                }
            }
            .alert("Очистить историю?", isPresented: $showingDeleteAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Очистить", role: .destructive) {
                    viewModel.clearHistory()
                    UserDefaults.standard.removeObject(forKey: "chatHistory")
                    UserDefaults.standard.synchronize()
                }
            } message: {
                Text("Это действие нельзя отменить")
            }
        }
    }
}
