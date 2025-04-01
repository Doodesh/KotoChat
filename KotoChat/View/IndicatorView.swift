//
//  IndicatorView.swift
//  KotoChat
//
//  Created by Musa Omarov on 31.03.2025.
//

import SwiftUI


// Анимация ожидания ответа (мигающие точки)
struct IndicatorView: View {
    @State private var dots = ""
    
    var body: some View {
        Text("Kot думает\(dots)")
            .font(.caption)
            .foregroundColor(.gray)
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                startAnimating()
            }
    }
    private func startAnimating() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if dots.count < 3 {
                dots.append(".")
            } else {
                dots = ""
            }
        }
    }
}
