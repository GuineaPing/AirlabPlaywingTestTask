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
                .padding(.top, 50)
            Image("playstore")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .padding(0)
            Text("v\(appVersion)")
                .foregroundStyle(.gray.opacity(0.8))
                .padding(.bottom, 50)
        }
        .containerShape(.rect)
        .onTapGesture {
            runCamera = true
        }
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
}

#Preview {
    AboutView(runCamera: Binding.constant(false))
        .padding(20)
}
