//
//  AboutView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 28.02.2025.
//

/*
    Displays an informational view with a title and an image.
    A tap gesture activates the camera.
*/
 
import SwiftUI

struct AboutView: View {
    @Binding var runCamera: Bool
    
    var body: some View {
        VStack {
            Text("Airlab&Playwing Test Task")
                .font(.title)
                .foregroundStyle(.gray.opacity(0.5))
                .padding(.top, 100)
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

#Preview {
    AboutView(runCamera: Binding.constant(false))
}
