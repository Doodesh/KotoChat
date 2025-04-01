//
//  ChatDetailView.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import SwiftUI

struct ChatDetailView: View {
    let messages: [Message]
    
    var body: some View {
        List(messages, id: \.id) { message in
            MessageView(message: message, viewModel: TextViewModel())
                .listRowBackground(Color("ColorB"))
        }
        .navigationTitle("Детали чата")
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .background {
            Color("ColorB")
                .ignoresSafeArea()
        }
    }
}
