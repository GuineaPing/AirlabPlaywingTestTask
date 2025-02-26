//
//  ContentView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "web.camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 35, height: 35)
                .foregroundStyle(.tint)
                .padding(.bottom, 20)
            Text("Airlab & Playwing")
                .font(.title2)
        }
        .padding(25)
    }
}

#Preview {
    ContentView()
}
