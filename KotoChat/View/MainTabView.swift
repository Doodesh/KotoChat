//
//  MainTabView.swift
//  KotoChat
//
//  Created by Musa Omarov on 30.03.2025.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = TextViewModel()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.iconColor = .colorA
        appearance.stackedLayoutAppearance.normal.iconColor = .colorC
        
        appearance.backgroundColor = UIColor(Color.colorB)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
    }
        
    
    var body: some View {
        TabView {
            ContentView(viewModel: viewModel)
                .tabItem {
                    Label("Чат", systemImage: "message")
                }
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("История", systemImage: "clock")
                }
        }
    }
        
}
    
