//
//  ContentView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

/*
    Main window displays a SwiftUI-based interface for camera operations and recording:

    1. Toggles Camera Modes:
       - Normal Mode: Uses CameraView to show the default real-time camera preview.
       - Black-and-White Mode: Utilizes CameraProcessingView for grayscale processing.

    2. Recording Management:
       - Allows the user to initiate or stop recording, contingent on the runCamera
         and saveVideo toggles.
       - Prompts for a save location via NSSavePanel, then checks and requests
         security-scoped resource access.
       - Removes any existing file at the selected location prior to recording.

    3. Device and State Management:
       - Observes AppSettings for a selected camera device and dynamically updates
         when the user changes the device.
       - Uses NotificationCenter to detect camera device changes.
       - Automatically switches between normal and black-and-white modes, stopping
         one session before starting the other.

    4. UI Structure:
       - A header control panel for toggles (runCamera, blackWhite, saveVideo).
       - The appropriate camera view (normal or processed) when running.
       - An AboutView placeholder for non-running state.
*/

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var runCamera: Bool = false
    private var cameraManager = CameraManager()
    @StateObject var settings = AppSettings()
    @State private var selectedID: String?
    @State var blackWhite: Bool  = false
    @State var processingRefresh: Bool = true
    @State var saveVideo: Bool = false
    
    var body: some View {
        VStack {
            HeaderView(
                runCamera: $runCamera,
                blackWhite: $blackWhite,
                saveVideo: $saveVideo)
            
            Spacer()
            if runCamera {
                if blackWhite && processingRefresh {
                    CameraProcessingView(selectedID: selectedID, isRun: blackWhite)
                        .frame(width: 640, height: 480) // 400 x 300
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                } else {
                    CameraView(session: cameraManager.session)
                        .frame(width: 640, height: 480)
                        .padding(.bottom, 20)
                }
            } else {
                AboutView(runCamera: $runCamera)
            }
            Spacer()
        }
        .onChange(of: runCamera, {
            toggleCamera()
        })
        .onChange(of: blackWhite, {
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
        
        if blackWhite {
            cameraManager.stopSession()
            refreshProcessingView()
        } else {
            cameraManager.toggleCamera(runCamera: runCamera, selectedID: selectedID)
            if runCamera {
                selectFile()
            }
        }
    }
    
    func selectFile() {
        if !saveVideo || !runCamera || blackWhite { return }
        
        pickSaveLocation { url in
            guard let fileURL = url else {
                print(">> canceled save panel or no URL returned.")
                return
            }
            checkAccess(url: fileURL)
            cameraManager.startRecording(to: fileURL)
        }
    }
    
    func checkAccess(url: URL) {
        if url.startAccessingSecurityScopedResource() {
            // Write or record to that URL here
            cameraManager.startRecording(to: url)
            url.stopAccessingSecurityScopedResource()
        } else {
            print(">> couldn't access security-scoped resource.")
        }
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.removeItem(at: url)
            } catch {
                print(">> failed to remove existing file: \(error)")
            }
        }
    }
    
    func pickSaveLocation(suggestedFileName: String = "Airtab-Playwing-Test.mov",
                          completion: @escaping (URL?) -> Void) {
        let panel = NSSavePanel()
        panel.title = "Choose Save Location"
        panel.nameFieldStringValue = suggestedFileName
        
        // Start the save panel
        panel.begin { response in
            if response == .OK, let url = panel.url {
                completion(url)
            } else {
                completion(nil)
            }
        }
    }
    
    func refreshProcessingView() {
        processingRefresh = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            processingRefresh = true
        }
    }
    
}

#Preview {
    ContentView()
}
