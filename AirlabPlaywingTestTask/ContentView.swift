//
//  ContentView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var runCamera: Bool = false
    @StateObject private var videoDevices = CameraListViewModel()
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        VStack {
            HeaderView(runCamera: $runCamera, cameras: $videoDevices.cameras)
            Spacer()
            if runCamera {
                CameraView(session: cameraManager.session)
                    .frame(width: 640, height: 480)
                    .padding(.bottom, 20)
            } else {
                aboutView
            }
            Spacer()
        }
        .onChange(of: runCamera, {
            if runCamera {
                cameraManager.startSession()
            } else {
                cameraManager.stopSession()
            }
        })
    }
    
    var aboutView: some View {
        VStack {
            Image(systemName: "camera")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundStyle(.tint)
                .padding(.bottom, 50)
        }
    }
}

#Preview {
    ContentView()
}
