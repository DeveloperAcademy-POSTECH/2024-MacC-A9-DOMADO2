//
//  ContentView.swift
//  DomadoV
//
//  Created by 이종선 on 10/7/24.
//

import SwiftUI

/// Coordinator를 활용해 현재 화면을 선택합니다. 
struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
