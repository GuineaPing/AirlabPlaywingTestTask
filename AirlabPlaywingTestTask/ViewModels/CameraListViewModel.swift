//
//  Untitled.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

/*
    Provides a view model for retrieving and managing available camera devices.
    Features:
    1. Uses AVCaptureDevice.DiscoverySession to scan for both built-in wide-angle and external cameras.
    2. Publishes an array of AVCaptureDevice objects for seamless integration with SwiftUI views.
    3. Logs the count and details (localized name, unique ID, connection status) of each camera for debugging.
    4. Implements a shared instance for convenient access across the application.
*/

import SwiftUI
import AVFoundation

class CameraListViewModel: ObservableObject {
    @Published var cameras: [AVCaptureDevice] = []
    
    static let shared = CameraListViewModel()
    
    init() {
        fetchCameras()
    }

    func fetchCameras() {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        )
        
        cameras = discoverySession.devices
        print(">> cameras count: \(cameras.count)")
        
        for camera in cameras {
            print(">> camera: \(camera.localizedName) — ID: \(camera.uniqueID), Connected: \(camera.isConnected)")
        }
    }
}
