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
    @StateObject var settings = AppSettings()
    @State private var selectedID: String?
    @State var blackWhite: Bool  = false
    
    var body: some View {
        VStack {
            HeaderView(runCamera: $runCamera, cameras: $videoDevices.cameras, blackWhite: $blackWhite)
            Spacer()
            if runCamera {
                if blackWhite {
                    CameraProcessingView(selectedID: selectedID)
                        .frame(width: 640, height: 480) // 400 x 300
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                } else {
                    CameraView(session: cameraManager.session)
                        .frame(width: 640, height: 480)
                        .padding(.bottom, 20)
                }
            } else {
                aboutView
            }
            Spacer()
        }
        .onChange(of: runCamera, {
            toggleCamera()
        })
        .onReceive(NotificationCenter.default.publisher(for: .operationDeviceChanged)) { cameraID in
            if let cameraID = cameraID.object as? String {
                selectedID = cameraID
                toggleCamera()
            }
        }
        .onAppear {
            selectedID = settings.selectedID
        }
    }
    
    func toggleCamera() {
        cameraManager.selectedID = selectedID
        if runCamera {
            if cameraManager.isSessionConfigured {
                cameraManager.restartSession()
            } else {
                cameraManager.startSession()
            }
        } else {
            cameraManager.stopSession()
        }
    }
    
    var aboutView: some View {
        VStack {
            Image("playstore")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding(.bottom, 50)
        }
        .containerShape(.rect)
        .onTapGesture {
            runCamera = true
        }
    }
}

#Preview {
    ContentView()
}
