//
//  MessageView.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import SwiftUI


struct MessageView: View {
    let message: Message
    @ObservedObject var viewModel: TextViewModel

    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.move(edge: .trailing))
            } else {
                Text(message.content)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .transition(.move(edge: .leading))
                Spacer()
            }
        }
        .padding(.horizontal) 
    }
}
