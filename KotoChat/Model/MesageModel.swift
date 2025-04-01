//
//  MesageModel.swift
//  KotoChat
//
//  Created by Musa Omarov on 31.03.2025.
//

import Foundation

struct Message: Codable, Identifiable {
    var id = UUID()
    let role: String
    let content: String
    let date: Date
    
    var timestamp: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var isUser: Bool {
        return role == "user"
    }
    
    init(role: String, content: String, date: Date = Date()) {
        self.role = role
        self.content = content
        self.date = date
    }
}
