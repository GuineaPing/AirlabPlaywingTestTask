//
//  Untitled.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

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
