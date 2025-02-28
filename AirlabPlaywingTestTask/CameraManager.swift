//
//  Untitled.swift
//  AirlabPlaywingTestTask
//
//  Created by Eugene Lysenko on 26.02.2025.
//

import AVFoundation
import SwiftUI
import Combine

class CameraManager: ObservableObject {
    let session = AVCaptureSession()
    var isSessionConfigured = false
    var isSessionRunning = false
    var selectedID: String?
    
    init() {
        // You can configure immediately, or lazily before startSession()
         configureSession()
    }
    
    private var defaultDevice: AVCaptureDevice? {
        guard let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .unspecified
        ) else {
            print(">> no camera found.")
            return nil
        }
        return device
    }
    
    private var selectedDevice: AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera, .external],
            mediaType: .video,
            position: .unspecified
        )
        let devices = discoverySession.devices

        if let device = devices.first(where: { $0.uniqueID == selectedID }) {
            return device
        } else {
            return nil
        }
    }
    
    func configureSession() {
        session.sessionPreset = .high
        session.beginConfiguration()
        
        do {
            // Add video input
            let videoInput = try AVCaptureDeviceInput(device: selectedDevice ?? defaultDevice!)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            // Add audio input only if authorized
            if AVCaptureDevice.authorizationStatus(for: .audio) == .authorized,
               let audioDevice = AVCaptureDevice.default(for: .audio) {
                let audioInput = try AVCaptureDeviceInput(device: audioDevice)
                if session.canAddInput(audioInput) {
                    session.addInput(audioInput)
                }
            }
            
            session.commitConfiguration()
            isSessionConfigured = true
        } catch {
            session.commitConfiguration()
            print(">> error configuring session: \(error)")
        }
    }
    
    func startSession() {
        guard isSessionConfigured, !isSessionRunning else { return }
        session.startRunning()
        isSessionRunning = true
        print(">> session started")
    }
    
    func stopSession() {
        guard isSessionRunning else { return }
        session.stopRunning()
        isSessionRunning = false
        print(">> session stoped")
    }
    
    func restartSession() {
        stopSession()
        
        session.beginConfiguration()
        // Remove existing inputs
        for input in session.inputs {
            session.removeInput(input)
        }
        session.commitConfiguration()
        
        // Reconfigure the session with new inputs
        configureSession()
        startSession()
    }
}
