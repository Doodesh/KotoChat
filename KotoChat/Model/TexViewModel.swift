//
//  TexViewModel.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//


import SwiftUI

// Класс для управления текстовыми сообщениями и историей чата
class TextViewModel: NSObject, ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var history: [[Message]] = []
    @Published var isLoading = false
    private let networkManager = GPTManager()
    private let historyKey = "chatHistory"
    private var currentContext: [Message] = []
    
    override init() {
        super.init()
        loadHistory()
    }
    
    // Метод для генерации ответа от GPT
    func generateText(prompt: String, completion: @escaping () -> Void) {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        let userMessage = Message(role: "user", content: prompt, date: Date())
        messages.append(userMessage)
        
        
        
        // Передаём ВСЮ текущую сессию
        networkManager.sendTextRequest(context: messages) { [weak self] response in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if response.hasPrefix("Error:") {
                    let errorMessage = Message(
                        role: "system",
                        content: "Ошибка: \(response). Попробуйте ещё раз.",
                        date: Date()
                    )
                    self.messages.append(errorMessage)
                } else {
                    let botMessage = Message(
                        role: "assistant",
                        content: response,
                        date: Date()
                    )
                    self.messages.append(botMessage)
                }
                
                self.isLoading = false
                completion()
            }
        }
    }
    
    
    // Метод для сохранения текущей сессии в историю
    func saveCurrentSession() {
        history.append(messages)
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    // Метод для загрузки истории чатов
    func loadHistory() {
        if let savedData = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([[Message]].self, from: savedData) {
            self.history = decodedHistory
        }
    }
    
    // Метод для очистки текущей сессии
    func clearCurrentSession() {
        saveCurrentSession()
        messages.removeAll()
    }
    
    func clearHistory() {
        history.removeAll()
        UserDefaults.standard.removeObject(forKey: historyKey)
        UserDefaults.standard.synchronize()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}
