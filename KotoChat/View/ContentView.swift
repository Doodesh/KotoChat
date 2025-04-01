//
//  ContentView.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import SwiftUI


struct ContentView: View {
       @ObservedObject var viewModel: TextViewModel
    @State private var userInput = ""
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.messages.isEmpty {
                    VStack {
                        Image("10")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 230)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                            .onTapGesture {
                                hideKeyboard()
                            }
                        Text("KotoChat")
                            .font(.system(size: 50, weight: .light))
                            .foregroundColor(.white.opacity(0.8))
                        
                    }
                } else {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }
                                
                                if viewModel.isLoading {
                                    IndicatorView()
                                        .transition(.opacity)
                                        .id(UUID())
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .onChange(of: viewModel.messages.count) {
                            scrollToBottom(proxy: proxy)
                        }
                        .onAppear {
                            scrollToBottom(proxy: proxy)
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                }
            }
            .padding(5)
            
            Spacer()
            

            MessageInputView(userInput: $userInput) {
                sendMessage()
            } onClear: {
                viewModel.clearCurrentSession()
            }
        }
        .background(Color.colorB)
    }
    private func sendMessage() {
        guard !userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        viewModel.generateText(prompt: userInput) {
            userInput = ""
            hideKeyboard()
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastId = viewModel.messages.last?.id {
            withAnimation {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
}



// Элемент сообщения
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
            HStack {
                if message.isUser {
                    Spacer()
                }
                
                VStack(alignment: message.isUser ? .trailing : .leading, spacing: 2) {
                    Text(message.content)
                        .padding()
                        .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(message.timestamp)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: message.isUser ? .trailing : .leading)
                
                if !message.isUser {
                    Spacer()
                }
            }
            .padding(.horizontal)
        }
    }
}

// Поле ввода сообщения
struct MessageInputView: View {
    @Binding var userInput: String
    let onSend: () -> Void
    let onClear: () -> Void
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if userInput.isEmpty {
                    Text("Задай вопрос")
                        .foregroundColor(.black)
                        .padding(.leading, 10)
                }
                
                TextField("", text: $userInput, axis: .vertical)
                    .lineLimit(1...5)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .onSubmit(onSend)
            }
            
            HStack {
                Button("Новый чат", action: onClear)
                    .frame(width: 120, height: 17)
                    .padding()
                    .background(Color.colorC)
                    .foregroundColor(.colorA)
                    .font(.system(size: 20, weight: .bold))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
                
                Button("Отправить", action: onSend)
                    .frame(width: 120, height: 17)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.colorC)
                    .font(.system(size: 20, weight: .bold))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
        }
        .padding(15)
        .background(Color.colorB)
    }
    
    
    
}
    

// Функция скрытия клавиатуры
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}







#Preview {
    MainTabView()
}

