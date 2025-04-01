//
//  GPTManager.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import Foundation


class GPTManager: ObservableObject {
    @Published var responses: [String] = []
    
    private let apiKey = "Введите API ключ"
    
    private let urlTextCompletion = "https://bothub.chat/api/v2/openai/v1/chat/completions"
    
    func sendTextRequest(context: [Message], completion: @escaping (String) -> Void) {
        guard let url = URL(string: urlTextCompletion) else {
            print("Invalid URL")
            completion("Error: Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let messagesArray: [[String: String]] = context.map { ["role": $0.role, "content": $0.content] }
        
        let requestDict: [String: Any] = [
            "model": "gpt-4o",
            "messages": messagesArray
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestDict)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion("Error: Network request failed")
                    }
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    DispatchQueue.main.async {
                        completion("Error: No data received")
                    }
                    return
                }
                
                do {
                    let response = try JSONDecoder().decode(APIResponse.self, from: data)
                    DispatchQueue.main.async {
                        if let content = response.choices.first?.message.content {
                            completion(content)
                        } else {
                            completion("Error: No content in response")
                        }
                    }
                } catch {
                    print("Decoding error: \(error)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Raw response: \(responseString)")
                    }
                    DispatchQueue.main.async {
                        completion("Error: Failed to decode response")
                    }
                }
            }.resume()
        } catch {
            print("Request encoding error: \(error.localizedDescription)")
            completion("Error: Failed to create request")
        }
    }
}
