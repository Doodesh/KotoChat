//
//  File.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import Foundation

struct APIResponse: Codable {
    let id: String
    let provider: String
    let model: String
    let object: String
    let created: Int
    let choices: [Choice]
    let systemFingerprint: String
    let usage: Usage
    
    enum CodingKeys: String, CodingKey {
        case id, provider, model, object, created, choices
        case systemFingerprint = "system_fingerprint"
        case usage
    }
}

struct Choice: Codable {
    let finishReason: String
    let index: Int
    let message: ChatMessage
    
    enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case index, message
    }
}

struct ChatMessage: Codable {
    let role: String
    let content: String
    let refusal: String?
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}


