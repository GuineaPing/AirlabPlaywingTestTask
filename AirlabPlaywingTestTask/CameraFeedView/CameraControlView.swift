//
//  CameraControlView.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 02.03.2025.
//

/*
Displays and controls the camera feed. It provides options to select a camera device from a list, toggle grayscale mode, and start/stop the feed manually, while also computing the resolution based on the selected device. For debug purposes only.
 */

import SwiftUI
import AVFoundation

// SwiftUI view with controls to switch modes, select camera, and start/stop the feed manually
struct CameraControlView: View {
    @State var useGrayscale = false
    @State var selectedID: String? = nil
    @State var isFeedRunning = true
    @State var fileURL: URL?
    let baseHeight: CGFloat = 480
    
    // Sample list of available cameras. In a real app, you would dynamically fetch this list.
    let availableCameras: [(name: String, id: String)] = [
        ("Default Camera", "47B4B64B-7067-4B9C-AD2B-AE273A71F4B5"),
        ("External Camera", "0x12000006f8300d")
    ]
    
    var body: some View {
        VStack {
            let resolution = deviceResolution(deviceID: selectedID)
            let height = CGFloat(baseHeight)
            let width = baseHeight * resolution.width / resolution.height
            CameraContainerView(
                    useGrayscale: $useGrayscale,
                    selectedID: $selectedID,
                    isFeedRunning: $isFeedRunning,
                    fileURL: $fileURL)
                .aspectRatio(resolution, contentMode: .fit)
                .frame(width: width, height: height)
                .clipped()
                .cornerRadius(5)
                .shadow(radius: 15)
                .padding()
            
            Picker("Select Camera", selection: $selectedID) {
                ForEach(availableCameras, id: \.id) { camera in
                    Text(camera.name)
                        .tag(Optional(camera.id))
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Toggle("Grayscale Mode", isOn: $useGrayscale)
                .padding()
                .font(.headline)
            
            Toggle("Feed Running", isOn: $isFeedRunning)
                .padding()
                .font(.headline)
        }
    }
    
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
}

struct CameraControlView_Previews: PreviewProvider {
    static var previews: some View {
        CameraControlView(
            useGrayscale: false,
            selectedID: "47B4B64B-7067-4B9C-AD2B-AE273A71F4B5",
            isFeedRunning: true)
    }
}
