//
//  AboutView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 28.02.2025.
//
 
import SwiftUI

struct AboutView: View {
    @Binding var runCamera: Bool
    
    var body: some View {
        VStack {
            Image("playstore")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .padding(.bottom, 50)
        }
        .containerShape(.rect)
        .onTapGesture {
            runCamera = true
        }
    }
}
