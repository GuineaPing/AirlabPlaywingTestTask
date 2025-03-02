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
    @StateObject var settings = AppSettings()
    @State private var selectedID: String?
    @State var blackWhite: Bool  = false
    @State var processingRefresh: Bool = true
    @State var saveVideo: Bool = false
    @State var fileURL: URL?
    let baseHeight: CGFloat = 480
    
    var body: some View {
        VStack {
            HeaderView(
                runCamera: $runCamera,
                blackWhite: $blackWhite,
                saveVideo: $saveVideo)
            
            Spacer()
            if runCamera && processingRefresh {
                let resolution = deviceResolution(deviceID: selectedID)
                let height = CGFloat(baseHeight)
                let width = baseHeight * resolution.width / resolution.height
                CameraContainerView(
                        useGrayscale: $blackWhite,
                        selectedID: $selectedID,
                        isFeedRunning: $runCamera,
                        fileURL: $fileURL)
                    .aspectRatio(resolution, contentMode: .fit)
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(5)
                    .shadow(radius: 15)
                    .padding()
                
            } else {
                AboutView(runCamera: $runCamera)
            }
            Spacer()
        }
        .onChange(of: runCamera, {
            if runCamera && saveVideo {
                selectFile()
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .operationDeviceChanged)) { cameraID in
            if let cameraID = cameraID.object as? String {
                selectedID = cameraID
            }
            refreshView()
        }
        .onAppear {
            selectedID = settings.selectedID
        }
    }
    
    // get resolution for selected devoce
    func deviceResolution(deviceID: String?) -> CGSize {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices
        var videoDevice: AVCaptureDevice?
        if let selectedID = selectedID {
            videoDevice = devices.first(where: { $0.uniqueID == selectedID })
        } else {
            videoDevice = AVCaptureDevice.default(for: .video)
        }
        if videoDevice == nil {
            return CGSize(width: CGFloat(640), height: CGFloat(480))
        }
        let dimensions = CMVideoFormatDescriptionGetDimensions(videoDevice!.activeFormat.formatDescription)
        return CGSize(width: CGFloat(dimensions.width), height: CGFloat(dimensions.height))
    }
    
    // select file for output
    func selectFile() {
        if !saveVideo || !runCamera { return }
        
        pickSaveLocation { url in
            guard let fileURL = url else {
                print(">> canceled save panel or no URL returned.")
                return
            }
            print(">> main fileURL \(fileURL.relativePath)")
            checkAccess(url: fileURL)

        }
    }
    
    // check access output file
    func checkAccess(url: URL) {
        if url.startAccessingSecurityScopedResource() {
            // Write or record to that URL here
            self.fileURL = url
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
    
    // pick output file name
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
    
    // suppress blinking on change feed
    func refreshView() {
        processingRefresh = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                processingRefresh = true
            }
        }
    }
}

#Preview {
    ContentView()
}
